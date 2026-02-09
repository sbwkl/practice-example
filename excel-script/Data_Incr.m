let
    Source = Excel.CurrentWorkbook(){[Name="Data_Stock"]}[Content],
    ChangeCodeType = Table.TransformColumnTypes(Source, {{"代码", type text}, {"程序代码", type text}}),
    GetTables = Table.AddColumn(ChangeCodeType, "StockData", each  EastMoneyLoader([程序代码])),
    ExpandDateValue = Table.ExpandTableColumn(GetTables, "StockData", {"date", "close"}),
    CombinedLongTable = Table.SelectColumns(ExpandDateValue, {"代码", "date", "close"}),

    PivotedTable = Table.Pivot(
        Table.TransformColumnTypes(CombinedLongTable, {{"date", type date}}), 
        List.Distinct(CombinedLongTable[代码]), 
        "代码", 
        "close", 
        List.Sum
    ),

    SortedData = Table.Sort(PivotedTable, {{"date", Order.Descending}})
in
    SortedData