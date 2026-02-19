let
    Source = Excel.CurrentWorkbook(){[Name="Data_Symbol"]}[Content],
    ChangeCodeType = Table.TransformColumnTypes(Source, {{"代码", type text}, {"程序代码", type text}}),
    GetTables = Table.AddColumn(ChangeCodeType, "MarketData", each  MarketDataLoader([程序代码])),
    ExpandDateValue = Table.ExpandTableColumn(GetTables, "MarketData", {"date", "value"}),
    CombinedLongTable = Table.SelectColumns(ExpandDateValue, {"代码", "date", "value"}),

    PivotedTable = Table.Pivot(
        Table.TransformColumnTypes(CombinedLongTable, {{"date", type date}}), 
        List.Distinct(CombinedLongTable[代码]), 
        "代码", 
        "value", 
        List.Sum
    ),

    SortedData = Table.Sort(PivotedTable, {{"date", Order.Descending}})
in
    SortedData