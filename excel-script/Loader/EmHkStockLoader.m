(code as text) =>
let
    TargetUrl = "https://33.push2his.eastmoney.com/api/qt/stock/kline/get?klt=101&fqt=0&lmt=50000&end=20500000&iscca=1&fields1=f1,f2,f3,f4,f5,f6&fields2=f51,f52,f53,f54,f55,f56,f57,f58,f59,f60,f61&secid=116."
    & code,
    Source = Json.Document(Web.Contents(TargetUrl, [
        Headers = [
            #"User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
            #"Accept" = "*/*"
        ]
    ])),
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
    RenameColumnName = Table.RenameColumns(FinalTable, {"close", "value"}),
    Final = Table.Sort(RenameColumnName, {"date", Order.Descending})
in
    Final