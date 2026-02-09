(code as text) =>
let
    TargetUrl = "
https://fund.sina.com.cn/fund/api/netWorth?callback=&t=11&fundcode=" & code,
    Source = Json.Document(Web.Contents(TargetUrl)),
    JsonData = Source[data],
    Data = Table.FromRecords(JsonData),
    Selected = Data[[ENDDATE], [UNITNAV]],
    Renamed = Table.RenameColumns(Selected, {{"ENDDATE", "date"}, {"UNITNAV", "nav"}}),
    TypeDate = Table.TransformColumnTypes(Renamed, {{"date", type date}}),
    Typed = Table.TransformColumnTypes(TypeDate, {{"nav", type number}}),
    Final = Table.Sort(Typed,{{"date", Order.Descending}})
in
    Final