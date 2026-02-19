(code as text) =>
let
    Today = DateTime.ToText(DateTime.LocalNow(), "yyyyMMdd"),
    TargetUrl = "https://www.gffunds.com.cn/apistore/JsonService?service=MarketPerformance&method=NAV&op=queryNAVByFundcode&_mode=all&startdate=20150213"
        & "&fundcode=" & code
        & "&enddate=" & Today,
    Source = Json.Document(Web.Contents(TargetUrl)),
    JsonData = Source[data],
    Data = Table.FromRecords(JsonData),
    Selected = Data[[NAVDATE], [NAVUNIT]],
    Renamed = Table.RenameColumns(Selected, {{"NAVDATE", "date"}, {"NAVUNIT", "value"}}),
    TypeDate = Table.TransformColumnTypes(Renamed, {{"date", type date}}),
    Typed = Table.TransformColumnTypes(TypeDate, {{"value", type number}}),
    Final = Table.Sort(Typed,{{"date", Order.Descending}})
in
    Final