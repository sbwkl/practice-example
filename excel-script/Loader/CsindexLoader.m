(code as text) =>
let
    Today = DateTime.ToText(DateTime.LocalNow(), "yyyyMMdd"),
    TargetUrl = "https://www.csindex.com.cn/csindex-home/perf/index-perf?indexCode=" & code & "&startDate=20150101&endDate=" & Today,
    Source = Json.Document(Web.Contents(TargetUrl)),
    JsonData = Source[data],
    Data = Table.FromRecords(JsonData),
    Selected = Data[[tradeDate], [close]],
    Renamed = Table.RenameColumns(Selected, {{"tradeDate", "date"}, {"close", "point"}}),
    TypeDate = Table.TransformColumnTypes(Renamed, {{"date", type date}}),
    Typed = Table.TransformColumnTypes(TypeDate, {{"point", type number}}),
    Final = Table.Sort(Typed,{{"date", Order.Descending}})
in
    Final