let
    // ========== 1. 读取 Daily_Position 宽表 ==========
    Source = Excel.CurrentWorkbook(){[Name="Daily_Position"]}[Content],
    Typed = Table.TransformColumnTypes(Source, {{"date", type date}}),

    // 所有品种列 (排除 date)
    AllCodes = List.RemoveItems(Table.ColumnNames(Typed), {"date"}),

    // ========== 2. 加载分类映射 ==========
    Source_Category = LoadTable("Market-Data-Fund", "Data_Symbol"),
    Category_Map = Table.SelectColumns(Source_Category, {"代码", "一级"}),

    // 构建 Record: {代码 -> 一级分类}，XJ 映射为 "货币"
    MapRows = Table.ToRecords(Category_Map),
    CodeToCat = Record.FromList(
        List.Transform(MapRows, each Record.Field(_, "一级")),
        List.Transform(MapRows, each Record.Field(_, "代码"))
    ),
    GetCategory = (code as text) => 
        if code = "XJ" then "货币" 
        else try Record.Field(CodeToCat, code) otherwise "未分类",

    // 将每个品种列归类
    All_Categories = List.Distinct(List.Transform(AllCodes, each GetCategory(_))),

    // 构建 Record: {分类 -> 该分类下的列名列表}
    CategoryToColumns = Record.FromList(
        List.Transform(All_Categories, each 
            List.Select(AllCodes, (code) => GetCategory(code) = _)
        ),
        All_Categories
    ),

    // ========== 3. 逐行计算: 总净值 + 分类值 + 分类占比 (纯列运算) ==========
    Initial_Capital = 150000,
    
    // 3a. 添加净值列
    Add_Total = Table.AddColumn(Typed, "净值", each 
        let row = _ in
        List.Sum(List.Transform(AllCodes, each 
            let v = Record.Field(row, _) in if v = null then 0 else v
        )) / Initial_Capital,
        type number
    ),

    // 3b. 为每个分类直接添加占比列 "xx" (内部计算金额后直接除以总值)
    Add_Cat_Percent = List.Accumulate(
        All_Categories,
        Add_Total,
        (tbl, cat) => 
            let cols = Record.Field(CategoryToColumns, cat) in
            Table.AddColumn(tbl, cat, each 
                let 
                    row = _,
                    total = [净值] * Initial_Capital,
                    // 当场计算该分类对应的市值和
                    catVal = List.Sum(List.Transform(cols, each 
                        let v = Record.Field(row, _) in if v = null then 0 else v
                    ))
                in
                    if total = 0 then 0 else catVal / total,
                type number
            )
    ),

    // ========== 4. 精简列 & 排序 ==========
    KeepCols = {"date", "净值"} & All_Categories,
    Selected = Table.SelectColumns(Add_Cat_Percent, KeepCols),
    
    Sorted_Result = Table.Sort(Selected, {{"date", Order.Descending}})
in
    Sorted_Result