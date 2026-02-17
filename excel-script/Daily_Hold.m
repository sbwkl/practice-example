let
    // 取得交易数据
    Source_Trade = Excel.CurrentWorkbook(){[Name="Data_Roll"]}[Content],
    Typed_Source = Table.TransformColumnTypes(Source_Trade, {{"交易时间", type date}, {"份额", type number}, {"金额", type number}}),

    // 分离 现金(XJ) 与 基金交易
    Rows_XJ = Table.SelectRows(Typed_Source, each [代码] = "XJ"),
    Rows_Fund = Table.SelectRows(Typed_Source, each [代码] <> "XJ"),

    // 1. 处理基金交易：修正符号 (买入=正, 卖出=负)
    // 假设原始数据中 买入是负数，所以乘以 -1 变正
    Rows_Fund_Corrected = Table.TransformColumns(Rows_Fund, {
        {"份额", each _ * -1, type number},
        {"金额", each _ * -1, type number}
    }),

    // 2. 生成基金交易对应的现金流变动
    // 买入基金(金额>0) -> 现金减少; 卖出基金(金额<0) -> 现金增加
    // 所以现金变动 = 金额 * -1
    Cash_Flow_From_Fund = Table.SelectColumns(Rows_Fund_Corrected, {"交易时间", "金额"}),
    Cash_Side_Records = Table.TransformColumns(Cash_Flow_From_Fund, {{"金额", each _ * -1, type number}}),
    Cash_Side_Final = Table.RenameColumns(
        Table.AddColumn(Cash_Side_Records, "代码", each "XJ"), 
        {{"金额", "份额"}}
    ),

    // 3. 合并所有记录：修正后的基金记录 + 生成的现金流 + 原始现金存取(XJ)
    // 注意：Project/SelectColumn 可能会丢失其他列，但在后续 GroupBy 中只用到 时间、代码、份额
    Combined_Trade = Table.Combine({
        Table.SelectColumns(Rows_Fund_Corrected, {"交易时间", "代码", "份额"}),
        Table.SelectColumns(Cash_Side_Final, {"交易时间", "代码", "份额"}),
        Table.SelectColumns(Rows_XJ, {"交易时间", "代码", "份额"})
    }),
    
    Typed_Trade = Combined_Trade,
    
    // 2. 加载市场数据 & 优化填充
    
    // --- 【优化】只加载实际交易过的基金，减少无用列 ---
    RelevantCodes = List.Distinct(Typed_Trade[代码]),
    
    Source_Market = LoadTable("Market-Data-Fund", "Market_Data"),
    
    // 过滤列：只保留日期和相关基金
    MarketColumns = Table.ColumnNames(Source_Market),
    KeepColumns = {"date"} & List.Intersect({MarketColumns, RelevantCodes}),
    Pruned_Market = Table.SelectColumns(Source_Market, KeepColumns),
    
    // 2.1 确保按日期升序排序，以便 FillDown 生效
    Sorted_Market = Table.Sort(Pruned_Market, {{"date", Order.Ascending}}),
    
    // 2.2 获取所有基金列名 (排除 date 列)
    Fund_Columns = List.RemoveItems(Table.ColumnNames(Sorted_Market), {"date"}),
    
    // 2.3 向下填充 (核心优化：在宽表状态下直接填充，避免生成笛卡尔积)
    Filled_Wide_Market = Table.FillDown(Sorted_Market, Fund_Columns),
    
    // 2.4 逆透视并过滤日期
    Unpivoted_Market_Raw = Table.UnpivotOtherColumns(Filled_Wide_Market, {"date"}, "代码", "NetValue"),
    Filtered_Market = Table.SelectRows(Unpivoted_Market_Raw, each [date] >= #date(2015, 1, 1)),

    // 3. 处理 XJ (现金)
    All_Dates = List.Distinct(Filtered_Market[date]),
    XJ_Table = Table.FromColumns(
        {All_Dates, List.Repeat({"XJ"}, List.Count(All_Dates)), List.Repeat({1}, List.Count(All_Dates))}, 
        {"date", "代码", "NetValue"}
    ),
    
    // 4. 合并基金行情 + 现金行情
    Unpivoted_Market = Table.Combine({Filtered_Market, XJ_Table}),

    // 4. 处理交易数据聚合
    Grouped_Daily_Trade = Table.Group(Typed_Trade, {"交易时间", "代码"}, {
        {"DailyChange", each List.Sum([份额]), type number}
    }),

    // 5. 合并与计算
    Merged_Data = Table.NestedJoin(Unpivoted_Market, {"date", "代码"}, Grouped_Daily_Trade, {"交易时间", "代码"}, "TradeDetails", JoinKind.LeftOuter),
    Expanded_Trade = Table.ExpandTableColumn(Merged_Data, "TradeDetails", {"DailyChange"}),
    
    Sorted_For_Calc = Table.Sort(Expanded_Trade, {{"代码", Order.Ascending}, {"date", Order.Ascending}}),
    Replace_Nulls = Table.ReplaceValue(Sorted_For_Calc, null, 0, Replacer.ReplaceValue, {"DailyChange"}),

    // 6. 优化点2: 使用 List.Generate 替代 O(N^2) 的求和
    Grouped_For_RunningTotal = Table.Group(Replace_Nulls, {"代码"}, {
        {"AllData", (t) => 
            let
                Changes = t[DailyChange],
                // 高性能累加算法
                RunningTotal = List.Generate(
                    () => [i = 0, sum = Changes{0}],
                    each [i] < List.Count(Changes),
                    each [i = [i] + 1, sum = [sum] + Changes{i}],
                    each [sum]
                ),
                Result = Table.FromColumns(
                    Table.ToColumns(t) & {RunningTotal},
                    Table.ColumnNames(t) & {"Holdings"}
                )
            in
                Result
        }
    }),
    
    Expanded_RunningTotal = Table.ExpandTableColumn(Grouped_For_RunningTotal, "AllData", {"date", "NetValue", "Holdings"}),
    
    // --- 【优化】过滤掉持仓为 0 的记录 ---
    Filtered_Holdings = Table.SelectRows(Expanded_RunningTotal, each Number.Abs([Holdings]) > 0.000001), 

    Add_MarketValue = Table.AddColumn(Filtered_Holdings, "MarketValue", each [Holdings] * [NetValue], type number),

    // --- 【新增】关联一级分类 ---
    // 1. 加载分类信息表
    Source_Category = LoadTable("Market-Data-Fund", "Data_Symbol"),
    Category_Info = Table.SelectColumns(Source_Category, {"代码", "一级"}),
    
    // 2. 获取所有可能的分类列表 (用于后续展开列)
    // 加上 "货币" (XJ) 和 "未分类" (防止null)
    All_Categories = List.Distinct(List.Combine({Category_Info[一级], {"货币", "未分类"}})),
    
    // 3. 合并分类信息
    Joined_Category = Table.NestedJoin(Add_MarketValue, {"代码"}, Category_Info, {"代码"}, "CatData", JoinKind.LeftOuter),
    
    // 4. 展开并非空处理 (XJ -> 货币)
    Expanded_Category = Table.AddColumn(Joined_Category, "Category", each 
        if [代码] = "XJ" then "货币" 
        else if Table.IsEmpty([CatData]) then "未分类" 
        else Record.Field([CatData]{0}, "一级")
    ),
    
    // 5. 按日期分组并计算各类汇总
    Initial_Capital = 150000,
    
    // 构建展开用的列名列表：原始值列 + 占比列
    Value_Column_Names = List.Transform(All_Categories, each _ & "（值）"),
    All_Expand_Columns = List.Combine({Value_Column_Names, All_Categories}),
    
    Grouped_By_Date = Table.Group(Expanded_Category, {"date"}, {
        // 计算组合累计净值：总市值 / 初始投入
        {"Portfolio_Net_Value", each List.Sum([MarketValue]) / Initial_Capital, type number},
        
        {"Category_Details", (t) => 
            let
                Total_Market_Value = List.Sum(t[MarketValue]),
                Safe_Total = if Total_Market_Value = 0 then 1 else Total_Market_Value,
                
                ByCat = Table.Group(t, {"Category"}, {{"SumVal", each List.Sum([MarketValue]), type number}}),
                
                // 原始值 Record: "xx（值）" -> 金额
                Value_Keys = List.Transform(ByCat[Category], each _ & "（值）"),
                Value_Record = Record.FromList(ByCat[SumVal], Value_Keys),
                
                // 占比 Record: "xx" -> 百分比
                Cat_Percent = List.Transform(ByCat[SumVal], each _ / Safe_Total),
                Percent_Record = Record.FromList(Cat_Percent, ByCat[Category]),
                
                // 合并两个 Record
                Combined = Record.Combine({Value_Record, Percent_Record})
            in
                Combined
        }
    }),

    // 6. 展开分类数据列
    Expanded_Final = Table.ExpandRecordColumn(Grouped_By_Date, "Category_Details", All_Expand_Columns),
    
    // 7. 处理 null (某天没有某分类持仓)
    Actual_Exp_Cols = List.Intersect({Table.ColumnNames(Expanded_Final), All_Expand_Columns}),
    Replace_Null_Final = Table.ReplaceValue(Expanded_Final, null, 0, Replacer.ReplaceValue, Actual_Exp_Cols),

    Sorted_Result = Table.Sort(Replace_Null_Final, {{"date", Order.Descending}})
in
    Sorted_Result