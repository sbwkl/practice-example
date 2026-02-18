let
    // Source data from Data_Hold query
    Source = Excel.CurrentWorkbook(){[Name="Data_Hold"]}[Content],

    // Filter out the summary row (where 代码/Code is 'Total')
    FilteredRows = Table.SelectRows(Source, each ([代码] <> "Total") and [代码] <> "XJ"),
    
    // Add custom column for Name handling: append specific text if holding is 0
    // "持仓" is the holding column based on analysis of Data_Hold.m
    AddCustomName = Table.AddColumn(FilteredRows, "品种", each if [持仓] = 0 then [名称] & "（已清仓）" else [名称]),

    // Select only the required columns: Name and Return Rate
    SelectedColumns = Table.SelectColumns(AddCustomName, {"品种", "累计收益率"}),

    // Sort by return rate descending (implied by "Rank")
    SortedRows = Table.Sort(SelectedColumns, {{"累计收益率", Order.Ascending}}),
    Final = Table.TransformColumnTypes(SortedRows, {"累计收益率", Percentage.Type})
in
    Final