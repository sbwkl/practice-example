let
    // 1. 处理市场数据：逆透视宽表
    Source_Market = LoadTable("Market-Data-Fund", "Market_Data"),
    Unpivoted_Market = Table.UnpivotOtherColumns(Source_Market, {"date"}, "代码", "NetValue"),

    // 2. 处理交易数据
    Source_Trade = Excel.CurrentWorkbook(){[Name="Data_Roll"]}[Content],
    
    // 【关键改动】修正符号：将符号颠倒，买入变为正数，卖出变为负数
    Correct_Sign = Table.TransformColumns(Source_Trade, {
        {"份额", each _ * -1, type number}
    }),
    
    // 强制转换数据类型
    Typed_Trade = Table.TransformColumnTypes(Correct_Sign, {{"交易时间", type date}}),
    
    Grouped_Trade = Table.Group(Typed_Trade, {"代码"}, {
        "AllData", (t) => 
            let
                // 按 交易时间 排序
                Sorted = Table.Sort(t, {{"交易时间", Order.Ascending}}),
                AddedIndex = Table.AddIndexColumn(Sorted, "Index", 1, 1),
                // 计算累计持仓量 (此时份额已经是符号修正后的了)
                AddRunningTotal = Table.AddColumn(AddedIndex, "Holdings", each List.Sum(List.FirstN(AddedIndex[份额], [Index])))
            in
                AddRunningTotal
    }),
    Expanded_Trade = Table.ExpandTableColumn(Grouped_Trade, "AllData", {"交易时间", "Holdings"}),

    // 3. 合并市场价与持仓量
    Merged_Data = Table.NestedJoin(Unpivoted_Market, {"date", "代码"}, Expanded_Trade, {"交易时间", "代码"}, "TradeDetails", JoinKind.LeftOuter),
    Expanded_Holdings = Table.ExpandTableColumn(Merged_Data, "TradeDetails", {"Holdings"}),

    // 4. 按标的分组并向下填充 (补全非交易日的持仓)
    Sorted_For_Fill = Table.Sort(Expanded_Holdings, {{"代码", Order.Ascending}, {"date", Order.Ascending}}),
    Grouped_For_Fill = Table.Group(Sorted_For_Fill, {"代码"}, {
        "Filled", each Table.FillDown(_, {"Holdings"})
    }),
    Final_Long_Table = Table.ExpandTableColumn(Grouped_For_Fill, "Filled", {"date", "NetValue", "Holdings"}),

    // 5. 计算每日市值并汇总
    Replace_Nulls = Table.ReplaceValue(Final_Long_Table, null, 0, Replacer.ReplaceValue, {"Holdings"}),
    Add_MarketValue = Table.AddColumn(Replace_Nulls, "MarketValue", each [Holdings] * [NetValue], type number),
    
    // 生成最终的组合每日市值表
    Data_Net = Table.Group(Add_MarketValue, {"date"}, {{"Portfolio_Net_Value", each List.Sum([MarketValue]), type number}})
in
    Data_Net