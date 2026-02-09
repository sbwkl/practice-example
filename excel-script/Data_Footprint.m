let
    Source = Excel.Workbook(File.Contents("E:\ETF 拯救世界\Market-Data-Stock.xlsx"), null, true),
    BarSheet = Source{[Item="Market_Data_Stock", Kind="Sheet"]}[Data],
    Sorted = Table.PromoteHeaders(BarSheet, [PromoteAllScalars=true]),

    DataTradeRaw = Excel.CurrentWorkbook(){[Name="Data_Trade"]}[Content],
    DataTrade = Table.TransformColumnTypes(DataTradeRaw, {{"买入日期", type date}, {"卖出日期", type date}}),
    MergeTrade = (TargetTable as table, TargetCode as text) as table =>
        let
            AddCol = Table.AddColumn(TargetTable, "TempCode", each TargetCode, type text),
            MergeBuy  = Table.NestedJoin(AddCol,   {"date", "TempCode"}, DataTrade, {"买入日期", "代码"}, "TempBuy",  JoinKind.LeftOuter),
            MergeSell = Table.NestedJoin(MergeBuy, {"date", "TempCode"}, DataTrade, {"卖出日期", "代码"}, "TempSell", JoinKind.LeftOuter),
            ExpandBuy  = Table.ExpandTableColumn(MergeSell, "TempBuy",  {"买入价格"}),
            ExpandSell = Table.ExpandTableColumn(ExpandBuy, "TempSell", {"卖出价格"}),
            RemoveTemp = Table.RemoveColumns(ExpandSell, {"TempCode"}),
            Renamed = Table.RenameColumns(RemoveTemp, {{"买入价格", "买入" & TargetCode}, {"卖出价格", "卖出" & TargetCode}})
        in
            Renamed,
    CodeList = {"159920", "512980", "159938", "513180", "513050", "512880", "515180", "513500", "512660", "162411"},
    Merged = List.Accumulate(
        CodeList, 
        Sorted, 
        (state, current) => MergeTrade(state, current)
    ),
    Final = Table.RenameColumns(Merged, {
        {"159920", "恒生"}, 
        {"512980", "传媒"}, 
        {"159938", "医药"}, 
        {"513180", "恒科"}, 
        {"513050", "中概"}, 
        {"512880", "证券"}, 
        {"515180", "红利"}, 
        {"513500", "标普"}, 
        {"512660", "军工"}, 
        {"162411", "油气"}
    })
in
    Final