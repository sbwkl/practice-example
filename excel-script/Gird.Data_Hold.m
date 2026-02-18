let
    SymbolA  = LoadTable("Market-Data-Stock", "Data_Symbol"),
    SymbolUS = LoadTable("Market-Data-Stock-US", "Data_Symbol"),
    DataSymbol = Table.Combine({SymbolA, SymbolUS}),
    Workbook = Excel.CurrentWorkbook(),
    DataTrade = Workbook{[Name="Data_Trade"]}[Content],
    DataFootprint = Workbook{[Name="Data_Footprint"]}[Content],
    Renamed = Table.RenameColumns(DataFootprint, {
        // {"恒生", "恒生 ETF"}, 
        // {"传媒", "传媒 ETF"}, 
        // {"医药", "医药卫生 ETF"}, 
        // {"恒科", "恒生科技"}, 
        // {"中概", "中概互联"}, 
        // {"证券", "证券 ETF"}, 
        // {"红利", "100 红利"}, 
        // {"标普", "标普 500"}, 
        // {"军工", "军工 ETF"}, 
        // {"油气", "华宝油气"}
        {"恒生", "159920"}, 
        {"传媒", "512980"}, 
        {"医药", "159938"}, 
        {"恒科", "513180"}, 
        {"中概", "513050"}, 
        {"证券", "512880"}, 
        {"红利", "515180"}, 
        {"标普", "513500"}, 
        {"军工", "512660"}, 
        {"油气", "162411"},
        {"白银", "SIVR"},
        {"黄金", "GLDM"}
    }),
    Grouped = Table.Group(DataTrade, {"代码"}, {
        {"买入股数", each List.Sum([买入股数]), type number},
        {"买入金额", each List.Sum([买入金额]), type number},
        {"卖出股数", each List.Sum([卖出股数]) ?? 0, type number},
        {"卖出金额", each List.Sum([卖出金额]) ?? 0, type number},
        {"结利", each List.Sum([结利]) ?? 0, type number},
        {"留利润", each List.Sum([#"留利润（份）"]) ?? 0, type number}
    }),
    Source = Table.AddColumn(Grouped, "网格份额", each [买入股数] - [卖出股数] - [留利润]),
    AddLatestNav = Table.AddColumn(Source, "最新净值", each 
        let
            CurrentTarget = [代码],
            NonNull = Table.SelectRows(Renamed, each Record.Field(_, CurrentTarget) <> null),
            Value = Record.Field(NonNull{0}, CurrentTarget)
        in
            Value, 
        type number
    ),
    AddHold = Table.AddColumn(AddLatestNav, "持有金额", each ([网格份额] + [留利润]) * [最新净值]),
    AddPL = Table.AddColumn(AddHold, "累计收益", each [买入金额] + [卖出金额] + [持有金额]),
    AddName = Table.NestedJoin(AddPL, "代码", DataSymbol, "代码", "SymbolData", JoinKind.LeftOuter),
    ExpandName = Table.ExpandTableColumn(AddName, "SymbolData", {"名称"}),
    Selected = Table.SelectColumns(ExpandName, {"代码", "名称", "网格份额", "留利润", "最新净值", "持有金额", "结利", "累计收益"}),
    Final = Table.TransformColumnTypes(Selected, {{"代码", type text}})
in
    Final