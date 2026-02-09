let
    Workbook = Excel.CurrentWorkbook(),
    DataTrade = Workbook{[Name="Data_Trade"]}[Content],
    DataFootprint = Workbook{[Name="Data_Footprint"]}[Content],
    Renamed = Table.RenameColumns(DataFootprint, {
        {"恒生", "恒生 ETF"}, 
        {"传媒", "传媒 ETF"}, 
        {"医药", "医药卫生 ETF"}, 
        {"恒科", "恒生科技"}, 
        {"中概", "中概互联"}, 
        {"证券", "证券 ETF"}, 
        {"红利", "100 红利"}, 
        {"标普", "标普 500"}, 
        {"军工", "军工 ETF"}, 
        {"油气", "华宝油气"}
    }),
    LatestNav = Renamed{0},
    Grouped = Table.Group(DataTrade, {"标的"}, {
        {"买入股数", each List.Sum([买入股数]), type number},
        {"买入金额", each List.Sum([买入金额]), type number},
        {"卖出股数", each List.Sum([卖出股数]), type number},
        {"卖出金额", each List.Sum([卖出金额]), type number},
        {"结利", each List.Sum([结利]), type number},
        {"留利润", each List.Sum([#"留利润（份）"]), type number}
    }),
    Source = Table.AddColumn(Grouped, "网格份额", each [买入股数] - [卖出股数] - [留利润]),
    AddLatestNav = Table.AddColumn(Source, "最新净值", each 
        let
            CurrentTarget = [标的],
            Value = Record.Field(LatestNav, CurrentTarget)
        in
            Value, 
        type number
    ),
    AddHold = Table.AddColumn(AddLatestNav, "持有金额", each ([网格份额] + [留利润]) * [最新净值]),
    AddPL = Table.AddColumn(AddHold, "累计收益", each [买入金额] + [卖出金额] + [持有金额]),
    Final = Table.SelectColumns(AddPL, {"标的", "网格份额", "留利润", "最新净值", "持有金额", "结利", "累计收益"})
in
    Final