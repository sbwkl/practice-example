let
    MarketDataStock = LoadTable("Market-Data-Stock", "Market_Data"),
    MarketDataStockUS = LoadTable("Market-Data-Stock-US", "Market_Data"),

    CodeListA = {"159920", "512980", "159938", "513180", "513050", "512880", "515180", "513500", "512660", "162411"},
    StockA  = Table.SelectColumns(MarketDataStock, {"date"} & CodeListA),
    CodeListUS = {"SIVR", "GLDM"},
    StockUS = Table.SelectColumns(MarketDataStockUS, {"date"} & CodeListUS),
    
    AllDatesList = List.Distinct(List.Union({StockA[date], StockUS[date]})),
    DateTable = Table.FromList(AllDatesList, Splitter.SplitByNothing(), {"date"}),
    
    SortedDateTable = Table.Sort(DateTable, {{"date", Order.Descending}}),

    MergedStockA = Table.NestedJoin(SortedDateTable, {"date"}, StockA, {"date"}, "DataA", JoinKind.LeftOuter),
    ExpandedStockA = Table.ExpandTableColumn(MergedStockA, "DataA", CodeListA),

    MergedStockUS = Table.NestedJoin(ExpandedStockA, {"date"}, StockUS, {"date"}, "DataUS", JoinKind.LeftOuter),
    GirdStock = Table.ExpandTableColumn(MergedStockUS, "DataUS", CodeListUS),

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
    Merged = List.Accumulate(
        CodeListA & CodeListUS, 
        GirdStock, 
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
        {"162411", "油气"},
        {"SIVR", "白银"},
        {"GLDM", "黄金"}
    })
in
    Final