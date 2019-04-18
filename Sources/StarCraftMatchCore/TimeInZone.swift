//
//  TimeInZone.swift
//  StarCraftMatchCore
//
//  Created by virus1994 on 2019/4/10.
//

import StORM
import SQLiteStORM

/// 赛区-战队关系
public class TeamInZone: SQLiteStORM {
    public var id: Int = 0
    /// 战队id
    public var teamid: Int = 0
    /// 赛区id
    public var zoneid: Int = 0
    /// 删除标记
    public var activeState: Int = 0
    
    override open func table() -> String {
        return "team_relate_zone"
    }
    
    override public func to(_ this: StORMRow) {
        id = this.data["id"] as? Int ?? 0
        teamid = this.data["teamid"] as? Int ?? 0
        zoneid = this.data["zoneid"] as? Int ?? 0
        activeState = this.data["activeState"] as? Int ?? 0
    }
    
    func rows() -> [TeamInZone] {
        var rows = [TeamInZone]()
        for i in 0..<self.results.rows.count {
            let item = TeamInZone()
            item.to(self.results.rows[i])
            rows.append(item)
        }
        return rows
    }
    
    /// 请求赛区内战队列表
    ///
    /// - Parameter zone: 赛区id
    /// - Returns: 赛区+战队列表，若没有有效战队信息则返回nil
    public func request(teamInZone zone: Int) -> (zone: Zone, values: [(recordID: Int, team: Team)])? {
        do {
            try self.find([("zoneid", "\(zone)"), ("activeState", "1")])
            let zone = Zone()
            try zone.get(zoneid)
            var teams = [(Int, Team)]()
            for item in self.rows() {
                let team = Team()
                try? team.get(item.teamid)
                guard team.id != 0 else { continue }
                teams.append((item.id, team))
            }
            
            log(message: "<<<<<< request team in zone: \(zone)")
            return (zone, teams)
        } catch {
            print(error)
            log(error: error.localizedDescription)
            return nil
        }
    }
}

/// 保存战队与赛区的关系
///
/// - Parameters:
///   - zoneTeamPack: 赛区id-战队id
///   - completion: 执行回调，成功返回true
public func save(zoneTeamPack: (zoneID: Int, teamsID: [Int]), completion: ExcuteCompletion?) {
    let data = TeamInZone()
    func saveNonSave(packs: (zoneID: Int, teamsID: [Int])) {
        packs.teamsID.forEach({
            let pair = TeamInZone()
            pair.activeState = 1
            pair.teamid = $0
            pair.zoneid = packs.zoneID
            do {
                try pair.save(set: {(id) in
                    data.id = id as! Int
                })
            } catch {
                log(error: error.localizedDescription)
            }
        })
    }
    
    for x in zoneTeamPack.teamsID {
        do {
            let r = TeamInZone()
            try r.find([("teamid", "\(x)"), ("activeState", "1")])
            let rows = r.rows()
            for y in rows {
                remove(teamZoneID: y.id) { (ok) in
                    if ok {
                        
                    }
                }
            }
        } catch StORMError.noRecordFound {
            
        } catch {
            log(error: error.localizedDescription)
            completion?(false)
            break
        }
    }
    
    do {
        try data.find([("zoneid", "\(zoneTeamPack.zoneID)")])
        let originRows = data.rows()
        var rows = originRows
        let unsignedTeam = zoneTeamPack.teamsID.filter({ t in !originRows.contains(where: { tz in tz.teamid == t }) })
        
        for i in originRows.enumerated() {
            for j in zoneTeamPack.teamsID {
                if i.element.teamid == j {
                    i.element.activeState = 1
                    try i.element.save()
                    rows.remove(at: i.offset)
                    break
                }
            }
        }
                
        saveNonSave(packs: (zoneID: zoneTeamPack.zoneID, teamsID: unsignedTeam))
        
        completion?(true)
    } catch StORMError.noRecordFound {
        saveNonSave(packs: zoneTeamPack)
    } catch {
        log(error: error.localizedDescription)
        completion?(false)
    }
}

/// 删除失效战队-赛区
///
/// - Parameters:
///   - teamZoneID: 记录id，通过request方法获取
///   - completion: 执行回调，成功返回true
public func remove(teamZoneID: Int, completion: ExcuteCompletion?) {
    let data = TeamInZone()
    do {
        try data.update(data: [("activeState", 0)], idValue: teamZoneID)
        try data.get(teamZoneID)
        log(message: "------ delete team-zone: \(data.id), state: \(data.activeState)")
        completion?(true)
    } catch {
        print(error)
        log(error: error.localizedDescription)
        completion?(false)
    }
}

/// 读取指定状态的赛区-战队数据，无排序
///
/// - Parameter teamState: 状态
/// - Returns: 赛区-战队关系数组数据
public func read(teamvZoneState: Int) -> [TeamInZone] {
    do {
        let x = TeamInZone()
        try x.find([("activeState", "\(teamvZoneState)")])
        return x.rows()
    } catch {
        log(error: error.localizedDescription)
        return []
    }
}
