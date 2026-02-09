(code as text) =>
let
    TargetUrl = "https://www.fullgoal.com.cn/ws-business-server/fund/getFundNavList?endDate=&isExport=&queryMonth=&selectTime=&startDate=2015-11-20&transNo=&fundType=1&siteno=main&merchantId=0&productCode=" & code,
    Source = Json.Document(Web.Contents(TargetUrl)),
    JsonData = Source[data],
    Data = Table.FromRecords(JsonData),
    Selected = Data[[navDate], [relatePrice]],
    Renamed = Table.RenameColumns(Selected, {{"navDate", "date"}, {"relatePrice", "nav"}}),
    TypeDate = Table.TransformColumnTypes(Renamed, {{"date", type date}}),
    Typed = Table.TransformColumnTypes(TypeDate, {{"nav", type number}}),
    Final = Table.Sort(Typed,{{"date", Order.Descending}})
in
    Final