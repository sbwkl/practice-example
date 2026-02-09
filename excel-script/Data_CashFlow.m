let
    Workbook = Excel.CurrentWorkbook(),
    DataTrade = Workbook{[Name="Data_Trade"]}[Content],
    Cashflow_Buy = Table.SelectRows(DataTrade, each [买入日期] <> null),
    Select_Buy = Table.SelectColumns(Cashflow_Buy, {"买入日期", "买入金额", "标的"}),
    Rename_Buy = Table.RenameColumns(Select_Buy, {{"买入日期", "日期"}, {"买入金额", "金额"}}),

    Cashflow_Sell = Table.SelectRows(DataTrade, each [卖出日期] <> null),
    Select_Sell = Table.SelectColumns(Cashflow_Sell, {"卖出日期", "卖出金额", "标的"}),
    Rename_Sell = Table.RenameColumns(Select_Sell, {{"卖出日期", "日期"}, {"卖出金额", "金额"}}),

    CombinedCashflow = Table.Combine({Rename_Buy, Rename_Sell}),
    Sorted = Table.Sort(CombinedCashflow, {"日期", Order.Ascending}),

    TodayCash = Table.AddColumn(Data_Hold, "日期", each DateTime.Date(DateTime.LocalNow()), type date),
    TodaySelected = Table.SelectColumns(TodayCash, {"日期", "持有金额", "标的"}),
    TodayRenamed = Table.RenameColumns(TodaySelected, {"持有金额", "金额"}),
    Combined = Table.Combine({Sorted, TodayRenamed}),
    Final = Table.TransformColumnTypes(Combined, {"日期", type date})
in
    Final