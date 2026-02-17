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
    Data_Net = Table.Group(Add_MarketValue, {"date"}, {{"Portfolio_Net_Value", each List.Sum([MarketValue]), type number}}),
    Sorted_Result = Table.Sort(Data_Net, {{"date", Order.Descending}})
in
    Sorted_Result