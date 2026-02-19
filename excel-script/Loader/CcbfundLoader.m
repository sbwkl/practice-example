(code as text) =>
let
    Source = Json.Document(Web.Contents("https://www.ccbfund.cn/website/v1/api/fund/chart?fundCode=" & code)),
    JsonData = Source[data],
    JsonList = JsonData[list],
    Data = Table.FromRecords(JsonList),
    Selected = Data[[date], [netValue]],
    Renamed = Table.RenameColumns(Selected, {"netValue", "value"}),
    TypeDate = Table.TransformColumnTypes(Renamed, {{"date", type date}}),
    TypeNav = Table.TransformColumnTypes(TypeDate, {{"value", type number}}),
    Final = Table.Sort(TypeNav,{{"date", Order.Descending}})
in
    Final