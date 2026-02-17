let
    Source = Excel.CurrentWorkbook(){[Name="Data_Roll"]}[Content],
    NonNull = Table.SelectRows(Source, each ([代码] <> null and [代码] <> "XJ")),
    Grouped = Table.Group(NonNull, {"代码"}, {
        {"份数", each Number.Abs(Number.Round(List.Sum([份数]), 2)), type number}, 
        {"份额", each Number.Abs(Number.Round(List.Sum([份额]), 2)), type number},
        {"总投入", each Number.Round(List.Sum(List.Select([金额], each _ < 0)) * -1, 2), type number},
        {"净投入", each Number.Round(List.Sum([金额]), 2), type number}
    }),

    WarehousePath = "E:\ETF 拯救世界\Market-Data-Fund.xlsx",
    WarehouseWorkbook = Excel.Workbook(File.Contents(WarehousePath), null, true),

    // 3. 提取基金基础信息表 (fund sheet)
    FundBaseInfo = WarehouseWorkbook{[Item="Data_Symbol", Kind="Sheet"]}[Data],
    FundBaseTable = Table.PromoteHeaders(FundBaseInfo, [PromoteAllScalars=true]),
    
    SheetData = WarehouseWorkbook{[Item="Market_Data", Kind="Sheet"]}[Data],
    FundMarketData = Table.PromoteHeaders(SheetData, [PromoteAllScalars=true]),
    // FundMarketData = Table.Buffer(PromotedData),

    // 4. 定义一个核心函数：根据每一个 code 去抓取净值
    GetLatestNav = (targetCode as text) =>
        let
            // 尝试定位名为 targetCode 的 Sheet
            // 使用 try...otherwise 防止某个 code 对应的 sheet 不存在导致整体崩溃
            Result = try 
                let
                    // 假设日期列叫 "日期"，净值列叫 "净值"，按日期倒序取第一行
                    NonNull = Table.SelectRows(FundMarketData, each 
                        let 
                            columnValue = Record.Field(_, targetCode) 
                        in 
                            columnValue <> null
                    ),
                    // Sorted = Table.Sort(NonNull, {{"date", Order.Descending}}),
                    LatestValue = Record.Field(NonNull{0}, targetCode)
                in
                    LatestValue
            otherwise null
        in
            Result,

    // 5. 开始合并数据
    // A. 关联基础行信息 (从 fund 表里匹配对应的行)
    JoinBaseInfo = Table.NestedJoin(Grouped, {"代码"}, FundBaseTable, {"代码"}, "BaseDetails", JoinKind.LeftOuter),
    ExpandedBase = Table.ExpandTableColumn(JoinBaseInfo, "BaseDetails", {"名称", "一级", "二级", "三级"}),

    // B. 调用函数获取最新净值
    AddNavColumn = Table.AddColumn(ExpandedBase, "最新净值", each GetLatestNav(Text.From([代码]))),
    AddCashRow = Table.InsertRows(
        AddNavColumn, 
        Table.RowCount(AddNavColumn), 
        {[
            代码 = "XJ", 
            份数 = List.Sum(Source[份数]),
            份额 = (List.Sum(Source[金额])),
            总投入 = 0,
            净投入 = 0,
            名称 = "现金",
            一级 = "货币",
            二级 = "货币",
            三级 = "货币",
            最新净值 = 1
        ]}
    ),
    AddPosColumn = Table.AddColumn(AddCashRow, "持仓", each Number.Round([份额] * [最新净值], 2)),
    TotalHold = List.Sum(AddPosColumn[持仓]),
    AddPercent = Table.AddColumn(AddPosColumn, "占比", each [持仓] / TotalHold, Percentage.Type),
    
    // Add Profit Columns
    AddProfit = Table.AddColumn(AddPercent, "累计收益", each if [代码] = "XJ" then 0 else Number.Round([持仓] + [净投入], 2), type number),
    AddProfitRate = Table.AddColumn(AddProfit, "累计收益率", each if [代码] = "XJ" or [总投入] = 0 then 0 else [累计收益] / [总投入], Percentage.Type),

    Reranked = Table.SelectColumns(AddProfitRate, {"代码", "名称", "份数", "份额", "最新净值", "持仓", "占比", "累计收益", "累计收益率", "一级", "二级", "三级", "总投入"}),
    SortByHold = Table.Sort(Reranked, {{"持仓", Order.Descending}}),
    
    TotalProfit = List.Sum(SortByHold[累计收益]),
    TotalInvest = List.Sum(SortByHold[总投入]),

    TotalRow = Table.FromRecords({[
        代码 = "Total",
        名称 = "汇总合计",
        份数 = List.Sum(SortByHold[份数]),
        份额 = null,
        最新净值 = null,
        持仓 = List.Sum(SortByHold[持仓]),
        占比 = List.Sum(SortByHold[占比]),
        累计收益 = TotalProfit,
        累计收益率 = if TotalInvest = 0 then 0 else TotalProfit / TotalInvest,
        一级 = "",
        二级 = "",
        三级 = ""
    ]}),
    FinalResult = Table.Combine({Table.RemoveColumns(SortByHold, {"总投入"}), TotalRow}),
    TypedResult = Table.TransformColumnTypes(FinalResult, {{"累计收益率", Percentage.Type}})
in
    TypedResult