let
    // ========== 1. 加载 Data_Roll 并设置类型 ==========
    Source = Excel.CurrentWorkbook(){[Name="Data_Roll"]}[Content],
    Typed = Table.TransformColumnTypes(Source, {
        {"交易时间", type date}, 
        {"金额", type number}, 
        {"份额", type number},
        {"买卖价格", type number},
        {"手续费", type number},
        {"份数", type number}
    }),

    // ========== 2. 处理交易数据 (小表优先) ==========
    Rows_Fund = Table.SelectRows(Typed, each [代码] <> "XJ"),
    Rows_XJ   = Table.SelectRows(Typed, each [代码] = "XJ"),

    // 修正符号: 买入份额<0 → *-1 → 正(持仓增), 卖出份额>0 → *-1 → 负(持仓减)
    Rows_Fund_Corrected = Table.TransformColumns(Rows_Fund, {
        {"份额", each _ * -1, type number},
        {"金额", each _ * -1, type number}
    }),

    // 2a. 基金份额变动
    Fund_Share_Records = Table.SelectColumns(Rows_Fund_Corrected, {"交易时间", "代码", "份额"}),

    // 2b. 现金变动 (买入→现金减少)
    Cash_From_Fund = Table.RenameColumns(
        Table.AddColumn(
            Table.SelectColumns(Rows_Fund_Corrected, {"交易时间", "金额"}),
            "代码", each "XJ", type text
        ),
        {{"金额", "份额"}}
    ),
    Cash_Side_Final = Table.TransformColumns(Cash_From_Fund, {{"份额", each _ * -1, type number}}),

    // 2c. 原始现金存取(XJ)
    XJ_Records = Table.SelectColumns(Rows_XJ, {"交易时间", "代码", "份额"}),

    // 2d. 合并 & 聚合每日变动
    All_Changes = Table.Combine({Fund_Share_Records, Cash_Side_Final, XJ_Records}),
    Daily_Aggregated = Table.Group(All_Changes, {"交易时间", "代码"}, {
        {"DailyChange", each List.Sum([份额]), type number}
    }),

    // 2e. 在小表上 List.Generate 计算累计持仓 (XJ 初始 150000)
    Initial_Capital = 150000,
    Sorted_Trade = Table.Sort(Daily_Aggregated, {{"代码", Order.Ascending}, {"交易时间", Order.Ascending}}),

    Cumulative_Trade = Table.Group(Sorted_Trade, {"代码"}, {
        {"SubTable", (t) =>
            let
                Changes = t[DailyChange],
                Code = t[代码]{0},
                InitVal = if Code = "XJ" then Initial_Capital else 0,
                RunningTotal = List.Generate(
                    () => [i = 0, sum = InitVal + Changes{0}],
                    each [i] < List.Count(Changes),
                    each [i = [i] + 1, sum = [sum] + Changes{i}],
                    each [sum]
                ),
                Result = Table.FromColumns(
                    {t[交易时间], RunningTotal},
                    {"交易时间", "Holdings"}
                )
            in
                Result
        }
    }),
    Expanded_Cumulative = Table.ExpandTableColumn(Cumulative_Trade, "SubTable", {"交易时间", "Holdings"}),
    // 结果: 稀疏表 {代码, 交易时间, Holdings} — 仅交易日有值

    RelevantCodes = List.Distinct(Expanded_Cumulative[代码]),
    FundCodes = List.RemoveItems(RelevantCodes, {"XJ"}),

    // 2f. Pivot 小表为宽格式, 列名加 _H 后缀避免与净值列冲突
    Pivoted_Holdings = Table.Pivot(Expanded_Cumulative, RelevantCodes, "代码", "Holdings", List.Sum),
    HoldingsColNames = List.Transform(RelevantCodes, each _ & "_H"),
    HoldingsRenameMap = List.Transform(RelevantCodes, each {_, _ & "_H"}),
    Renamed_Holdings = Table.RenameColumns(
        Table.RenameColumns(Pivoted_Holdings, {{"交易时间", "date"}}),
        HoldingsRenameMap
    ),

    // ========== 3. 加载市场数据 (宽表, 数据已完整, 无需 FillDown) ==========
    Source_Market = LoadTable("Market-Data-Fund", "Market_Data"),
    MarketColumns = Table.ColumnNames(Source_Market),
    KeepColumns = {"date"} & List.Intersect({MarketColumns, FundCodes}),
    Pruned_Market = Table.SelectColumns(Source_Market, KeepColumns),
    Filtered_Market = Table.SelectRows(Pruned_Market, each [date] >= #date(2018, 8, 1)),
    Sorted_Market = Table.Sort(Filtered_Market, {{"date", Order.Ascending}}),

    // ========== 4. 单次 Join: 宽表市场数据 + 宽表持仓 ==========
    Joined = Table.NestedJoin(Sorted_Market, {"date"}, Renamed_Holdings, {"date"}, "CumData", JoinKind.LeftOuter),
    Expanded = Table.ExpandTableColumn(Joined, "CumData", HoldingsColNames),

    // FillDown 持仓列 (在宽表上各列独立, 不会跨品种污染)
    Filled = Table.FillDown(Expanded, HoldingsColNames),
    // 首次交易前的日期 → 0
    NoNulls = Table.ReplaceValue(Filled, null, 0, Replacer.ReplaceValue, HoldingsColNames),

    // ========== 5. 计算每日持仓金额 = 累计份额 × 当日净值 ==========
    // List.Accumulate 逐列添加, 引擎按列批处理更高效
    WithFundMV = List.Accumulate(
        FundCodes,
        NoNulls,
        (tbl, code) => Table.AddColumn(
            tbl, code & "_MV",
            each Record.Field(_, code) * Record.Field(_, code & "_H"),
            type number
        )
    ),
    // XJ: 净值恒为1, 市值=余额
    WithXJ_MV = Table.RenameColumns(WithFundMV, {{"XJ_H", "XJ"}}),

    // ========== 6. 精简列: 只保留 date + 各品种市值 + XJ ==========
    FundMVCols = List.Transform(FundCodes, each _ & "_MV"),
    Selected = Table.SelectColumns(WithXJ_MV, {"date"} & FundMVCols & {"XJ"}),
    FinalRenameMap = List.Transform(FundCodes, each {_ & "_MV", _}),
    Renamed_Final = Table.RenameColumns(Selected, FinalRenameMap),

    // ========== 7. 排序输出 ==========
    Sorted_Result = Table.Sort(Renamed_Final, {{"date", Order.Descending}})
in
    Sorted_Result
