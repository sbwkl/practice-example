let
    Source = Excel.CurrentWorkbook(){[Name="Data_Hold"]}[Content],
    Hold = Table.SelectRows(Source, each ([持仓] > 0 and [代码] <> "Total")),
    GroupL1 = Table.Group(Hold, {"一级"}, {{"一级份数", each Number.Round(List.Sum([份数]), 2), type number}, {"一级占比", each List.Sum([占比]), type number}}),
    GroupL2 = Table.Group(Hold, {"一级", "二级"}, {{"二级份数", each Number.Round(List.Sum([份数]), 2), type number}, {"二级占比", each List.Sum([占比]), type number}}),
    GroupL3 = Table.Group(Hold, {"一级", "二级", "三级"}, {{"三级份数", each Number.Round(List.Sum([份数]), 2), type number}, {"三级占比", each List.Sum([占比]), type number}}),
    
    MergeL2 = Table.NestedJoin(GroupL3, {"一级", "二级"}, GroupL2, {"一级", "二级"}, "L2", JoinKind.LeftOuter),
    ExpandL2 = Table.ExpandTableColumn(MergeL2, "L2", {"二级份数", "二级占比"}),
    MergeL1 = Table.NestedJoin(ExpandL2, {"一级"}, GroupL1, {"一级"}, "L1", JoinKind.LeftOuter),
    ExpandL1 = Table.ExpandTableColumn(MergeL1, "L1", {"一级份数", "一级占比"}),

    Sorted = Table.Sort(ExpandL1, {{"一级占比", Order.Descending}, {"二级占比", Order.Descending}, {"三级占比", Order.Descending}}),
    AddL1Column = Table.AddColumn(Sorted, "市场",
        each [一级] & "【" & Text.From([一级份数]) & "】" & " " &  Number.ToText([一级占比], "P2"), type text),
    AddL2Column = Table.AddColumn(AddL1Column, "大类", 
        each [二级] & "【" & Text.From([二级份数]) & "】" & " " &  Number.ToText([二级占比], "P2"), type text),
    AddL3Column = Table.AddColumn(AddL2Column, "小类", 
        each [三级] & "【" & Text.From([三级份数]) & "】", type text),
    Final = Table.SelectColumns(AddL3Column, {"市场", "大类", "小类", "三级占比"})
in
    Final