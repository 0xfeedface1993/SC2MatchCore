import XCTest
@testable import StarCraftMatchCore

final class StarCraftMatchCoreTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(StarCraftMatchCore().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample), ("testTeamDB", testTeamDB)
    ]
    
    func testZoneDB() {
        configDatabase()
        
        deleteAllTeamRecords()
        deleteAllZoneRecords()
        deleteAllTeamZoneRecords()
        
        // 单个添加记录
        save(zone: "美洲") { (isSuccess) in
            XCTAssert(isSuccess, "*** 插入或更新赛区数据失败")
        }
        
        // 批量添加记录
        save(zones: ["美洲", "太平洋", "亚洲"]) { (isSuccess) in
            XCTAssert(isSuccess, "*** 批量插入或更新赛区数据失败")
        }
        
        let rows = read(zoneState: 1)
        XCTAssert(rows.count == 3, "*** 批量插入或更新赛区数据失败")
        
        // 更新数据
        update(zone: rows[0].id, name: "大风州") { (isSuccess) in
            XCTAssert(isSuccess, "*** 批量更新赛区数据失败")
        }
        
        // 删除数据，使用id
        remove(zoneID: rows[0].id) { (isSuccess) in
            XCTAssert(isSuccess, "*** 删除有效赛区数据失败")
        }
        
        // 删除数据，使用名称
        remove(zoneName: "亚洲") { (isSuccess) in
            XCTAssert(isSuccess, "*** 删除有效赛区数据失败")
        }
    }
    
    func testTeamDB() {
        configDatabase()
        
        deleteAllTeamRecords()
        deleteAllZoneRecords()
        deleteAllTeamZoneRecords()
        
        let teams = [("熊猫战队", "A"), ("北京战队", "B"), ("昆明战队", "C"), ("斗鱼战队", "D")]
        
        // 批量保存数据
        save(teamPack: teams) { (isSuccess) in
            XCTAssert(isSuccess, "*** 批量插入或更新战队数据失败")
        }
        
        let rows = read(teamState: 1)
        XCTAssert(rows.count == 4, "*** 批量插入或更新战队数据失败")
        
        // 更新战队信息
        update(team: rows[0].id, value: (team: "bilibili闪电", manager: "大风车")) { (isSuccess) in
            XCTAssert(isSuccess, "*** 更新战队数据失败")
        }
        
        // 删除战队
        remove(teamID: rows[0].id) { (isSuccess) in
            XCTAssert(isSuccess, "*** 删除战队赛区数据失败")
        }
    }
    
    func testTeamInZone() {
        configDatabase()
        
        deleteAllTeamRecords()
        deleteAllZoneRecords()
        deleteAllTeamZoneRecords()
        
        let teams = [("熊猫战队", "A"), ("北京战队", "B"), ("昆明战队", "C"), ("斗鱼战队", "D")]
        // 批量保存数据
        save(teamPack: teams) { (isSuccess) in
            XCTAssert(isSuccess, "*** 批量插入或更新战队数据失败")
        }
        
        let teamRows = read(teamState: 1)
        XCTAssert(teamRows.count == 4, "*** 批量插入或更新战队数据失败")
        
        let zones = ["美洲", "太平洋", "亚洲"]
        // 批量添加记录
        save(zones: zones) { (isSuccess) in
            XCTAssert(isSuccess, "*** 批量插入或更新赛区数据失败")
        }
        
        let z = Zone()
        try? z.findAll()
        let zoneRows = z.rows()
        
        let pack = (zoneRows[0].id, [teamRows[0].id, teamRows[2].id])
        
        save(zoneTeamPack: pack) { (isSuccess) in
            XCTAssert(isSuccess, "*** 批量插入或更新赛区-战队关系数据失败")
        }
        
        let x = TeamInZone()
        let newPack = x.request(teamInZone: zoneRows[0].id)
        XCTAssert(newPack != nil && newPack!.values.count == 2, "*** 该赛区-战队关系数据不存在")
        
        remove(teamZoneID: newPack!.values[0].recordID) { (isSuccess) in
            XCTAssert(isSuccess, "*** 删除赛区-战队关系数据失败")
        }
        
        let deletePack = x.request(teamInZone: zoneRows[0].id)
        XCTAssert(deletePack != nil && deletePack!.values.count == 1, "*** 删除赛区-战队关系数据失败")
    }
}
