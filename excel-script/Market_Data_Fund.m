let
    Source = Excel.CurrentWorkbook(){[Name="Data_Fund"]}[Content],
    FilteredRows = Table.SelectRows(Source, each ([LoaderName] <> null and [LoaderName] <> "")),

    GetTables = Table.AddColumn(FilteredRows, "FundData", each 
        let
            Func = Record.Field(#shared, [LoaderName]),
            RawTable = Func([代码]),
            Standardized = Table.RenameColumns(RawTable, {{"nav", "value"}})
        in
            Standardized
    ),

    ExpandDateValue = Table.ExpandTableColumn(GetTables, "FundData", {"date", "value"}),
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