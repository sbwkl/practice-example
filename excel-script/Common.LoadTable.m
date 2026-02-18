(file as text, tableName as text) =>
let
    Workbook = Excel.Workbook(File.Contents("E:\ETF 拯救世界\" & file & ".xlsx"), null, true),
    Sheet = Workbook{[Item=tableName, Kind="Sheet"]}[Data],
    TableData = Table.PromoteHeaders(Sheet, [PromoteAllScalars=true])
in
    TableData