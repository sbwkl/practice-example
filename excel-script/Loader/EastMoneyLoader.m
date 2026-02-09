(code as text) =>
let
    Today = DateTime.Date(DateTime.LocalNow()),
    ThirtyDaysAgo = Date.AddDays(Today, -30),
    End = Date.ToText(Today, "yyyyMMdd"),
    Beg = Date.ToText(ThirtyDaysAgo, "yyyyMMdd"),
    TargetUrl = "https://push2his.eastmoney.com/api/qt/stock/kline/get?fields1=f1,f2,f3,f4,f5,f6&fields2=f51,f52,f53,f54,f55,f56,f57,f58,f59,f60,f61,f116&ut=7eea3edcaed734bea9cbfc24409ed989&klt=101&fqt=1"
    & "&secid=" & code & "&beg=" & Beg & "&end=" & End,
    Source = Json.Document(Web.Contents(TargetUrl)),
    Data = Source[data][klines],
    RawTable = Table.FromList(Data, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    SplitTable = Table.SplitColumn(RawTable, "Column1", 
        Splitter.SplitTextByDelimiter(",", QuoteStyle.None), 
        {"date", "open", "close", "high", "low", "f1", "f2", "f3", "f4", "f5", "f6"}
    ),
    Selected = Table.SelectColumns(SplitTable, {"date", "close"}),
    FinalTable = Table.TransformColumnTypes(Selected, {
        {"date", type date}, 
        {"close", type number}
    }),
    Final = Table.Sort(FinalTable, {"date", Order.Descending})
in
    Final