(code as text) =>
let
    TargetUrl = "https://hq.cnindex.com.cn/market/market/getIndexDailyDataWithDataFormat?startDate=&endDate=&frequency=day&indexCode=" & code,
    Source = Json.Document(Web.Contents(TargetUrl, [Headers=[
        #"User-Agent"="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36"
    ]])),
    JsonData = Source[data],
    DataList = JsonData[data],
    ColList = JsonData[item],
    Data = Table.FromRows(DataList, ColList),
    Selected = Data[[timestamp], [current]],
    Renamed = Table.RenameColumns(Selected, {{"timestamp", "date"}, {"current", "value"}}),
    TypeDate = Table.TransformColumnTypes(Renamed, {{"date", type date}}),
    Typed = Table.TransformColumnTypes(TypeDate, {{"value", type number}}),
    Final = Table.Sort(Typed,{{"date", Order.Descending}})
in
    Final