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
        
        let z = Zone()
        try? z.findAll()
        
        let rows = z.rows()
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
        save(teamPack: teams) { (isSuccess) in
            XCTAssert(isSuccess, "*** 批量插入或更新战队数据失败")
        }
    }
}
