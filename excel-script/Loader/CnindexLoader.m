(code as text) =>
let
    TargetUrl = "https://hq.cnindex.com.cn/market/market/getIndexDailyDataWithDataFormat?startDate=&endDate=&frequency=day&indexCode=" & code,
    Source = Json.Document(Web.Contents(TargetUrl)),
    JsonData = Source[data],
    DataList = JsonData[data],
    ColList = JsonData[item],
    Data = Table.FromRows(DataList, ColList),
    Selected = Data[[timestamp], [current]],
    Renamed = Table.RenameColumns(Selected, {{"timestamp", "date"}, {"current", "point"}}),
    TypeDate = Table.TransformColumnTypes(Renamed, {{"date", type date}}),
    Typed = Table.TransformColumnTypes(TypeDate, {{"point", type number}}),
    Final = Table.Sort(Typed,{{"date", Order.Descending}})
in
    Final