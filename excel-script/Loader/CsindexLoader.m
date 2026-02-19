(code as text) =>
let
    Today = DateTime.ToText(DateTime.LocalNow(), "yyyyMMdd"),
    TargetUrl = "https://www.csindex.com.cn/csindex-home/perf/index-perf?indexCode=" & code & "&startDate=20150101&endDate=" & Today,
    Source = Json.Document(Web.Contents(TargetUrl, [Headers=[
        #"User-Agent"="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36"
    ]])),
    JsonData = Source[data],
    Data = Table.FromRecords(JsonData),
    Selected = Data[[tradeDate], [close]],
    Renamed = Table.RenameColumns(Selected, {{"tradeDate", "date"}, {"close", "value"}}),
    TypeDate = Table.TransformColumnTypes(Renamed, {{"date", type date}}),
    Typed = Table.TransformColumnTypes(TypeDate, {{"value", type number}}),
    Final = Table.Sort(Typed,{{"date", Order.Descending}})
in
    Final