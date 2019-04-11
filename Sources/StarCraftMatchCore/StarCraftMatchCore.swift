struct StarCraftMatchCore {
    var text = "Hello, World!"
}

/// 删除所有赛区数据
public func deleteAllZoneRecords() {
    let data = Zone()
    deleteAll(record: data)
}

/// 删除所有战队数据
public func deleteAllTeamRecords() {
    let data = Team()
    deleteAll(record: data)
}

/// 删除所有战队-赛区数据
public func deleteAllTeamZoneRecords() {
    let data = TeamInZone()
    deleteAll(record: data)
}

