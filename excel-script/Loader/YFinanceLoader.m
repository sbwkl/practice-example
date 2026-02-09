(code as text) =>
let
    TodayDate = DateTime.Date(DateTime.LocalNow()),
    StartOfDay = DateTime.From(TodayDate),
    Today = Duration.TotalSeconds(StartOfDay - #datetime(1970, 1, 1, 0, 0, 0)),
    TargetUrl = "https://query1.finance.yahoo.com/v8/finance/chart/"
    & code & "?events=capitalGain%7Cdiv%7Csplit&formatted=true&includeAdjustedClose=true&interval=1d&period1=1420070400&userYfid=true&lang=zh-Hant-HK&region=HK"
    & "&period2=" & Number.ToText(Today)
    & "&symbol=" & code,
    Source = Json.Document(Web.Contents(TargetUrl, [
        Headers = [
            #"User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
            #"Accept" = "*/*"
        ]
    ])),
    ColDate = Source[chart][result]{0}[timestamp],
    ColPrice = Source[chart][result]{0}[indicators][adjclose]{0}[adjclose],
    CustomTable = Table.FromColumns(
        {ColDate, ColPrice}, 
        {"date", "point"}
    ),
    TypedDate = Table.TransformColumns(CustomTable, {
        {"date", each Date.From(#datetime(1970, 1, 1, 0, 0, 0) + #duration(0, 0, 0, _) + #duration(0, 8, 0, 0)), type date}
    }),
    Typed = Table.TransformColumnTypes(TypedDate, {{"point", type number}}),
    NonNull = Table.SelectRows(Typed, each ([point] <> null)),
    Final = Table.Sort(NonNull, {{"date", Order.Descending}})
in
    Final