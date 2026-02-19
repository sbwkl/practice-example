(code as text) =>
let
    Source = Json.Document(Web.Contents("https://www.chinaamc.com/fund/" & code & "/zoust_all.js")),
    ColDate = Source[ShowData],
    ColNav  = Source[danweijingzhiName],
    Data = Table.FromColumns({ColDate, ColNav}, {"date", "value"}),
    TypeDate = Table.TransformColumnTypes(Data, {{"date", type date}}),
    Typed = Table.TransformColumnTypes(TypeDate, {{"value", type number}}),
    Final = Table.Sort(Typed,{{"date", Order.Descending}})
in
    Final