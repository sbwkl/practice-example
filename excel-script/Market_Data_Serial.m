let
    Source = Excel.CurrentWorkbook(){[Name="Data_Symbol"]}[Content],
    ChangeType = Table.TransformColumnTypes(Source, {{"代码", type text}, {"程序代码", type text}}),
    FilteredRows = Table.SelectRows(ChangeType, each ([LoaderName] <> null and [LoaderName] <> "")),
    
    // 为了性能优化，先将表转换为记录列表，避免循环中频繁进行索引寻址
    Records = Table.ToRecords(FilteredRows),
    RowCount = List.Count(Records),

    GetDataByIndex = (index as number) =>
        let
            Current = Records{index},
            Func = Record.Field(#shared, Current[LoaderName]),
            RawTable = Function.InvokeAfter(() => Func(Current[程序代码]), #duration(0, 0, 0, 10))
        in
            RawTable,

    // 使用 List.Generate 强制串行执行
    GeneratedList = List.Generate(
        () => [i = 0, Data = GetDataByIndex(0)],
        (prev) => prev[i] < RowCount, // 使用 prev 指代上一轮的状态
        (prev) => 
            let
                index = prev[i], // 明确获取上一轮的索引
                Standardized = GetDataByIndex(index + 1)
            in
                [i = index + 1, Data = Standardized], // 明确传递下一轮
        (prev) => prev[Data]
    ),

    // 将生成的列表结果拼回原表
    CombineResults = Table.FromColumns(
        Table.ToColumns(FilteredRows) & {GeneratedList}, 
        Table.ColumnNames(FilteredRows) & {"IndexData"}
    ),

    // 后续处理：展开、筛选、透视
    ExpandDateValue = Table.ExpandTableColumn(CombineResults, "IndexData", {"date", "value"}),
    CombinedLongTable = Table.SelectColumns(ExpandDateValue, {"代码", "date", "value"}),

    // 透视步骤（加入 Text.From 解决你之前的数字类型报错问题）
    PivotedTable = Table.Pivot(
        Table.TransformColumnTypes(CombinedLongTable, {{"date", type date}}), 
        List.Transform(List.Distinct(CombinedLongTable[代码]), each Text.From(_)), 
        "代码", 
        "value", 
        List.Sum
    ),
    SortedData = Table.Sort(PivotedTable, {{"date", Order.Descending}})
in
    SortedData