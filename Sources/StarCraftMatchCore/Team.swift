//
//  Team.swift
//  PerfectTemplate
//
//  Created by virus1994 on 2019/4/9.
//

import StORM
import SQLiteStORM

public typealias ExcuteCompletion = (Bool) -> ()

/// 战队
public class Team: SQLiteStORM {
    public var id: Int = 0
    /// 名称
    public var name: String = ""
    /// 负责人（默认经理）
    public var mananger: String = ""
    /// 删除标记
    public var activeState: Int = 0
    
    override open func table() -> String {
        return "team"
    }
    
    override public func to(_ this: StORMRow) {
        id = this.data["id"] as? Int ?? 0
        name = this.data["name"] as? String ?? ""
        mananger = this.data["mananger"] as? String ?? ""
        activeState = this.data["activeState"] as? Int ?? 0
    }
    
    func rows() -> [Team] {
        var rows = [Team]()
        for i in 0..<self.results.rows.count {
            let item = Team()
            item.to(self.results.rows[i])
            rows.append(item)
        }
        return rows
    }
}

/// 保存战队信息，根据战队名查找存在记录，如果存在则更新记录
///
/// - Parameters:
///   - team: 战队名
///   - manager: 战队管理员
///   - completion: 执行回调，成功返回true
public func save(team: String, manager: String, completion: ExcuteCompletion?) {
    let data = Team()
    do {
        try data.find([("name", team)])
        data.activeState = 1
        data.name = team
        data.mananger = manager
        try data.save(set: { (id) in
            data.id = id as! Int
        })
        log(message: ">>>>>> update zone: \(data.name), state: \(data.activeState)")
        completion?(true)
    } catch {
        print(error)
        log(error: error.localizedDescription)
        completion?(false)
    }
}

/// 保存或更新多条战队记录
///
/// - Parameters:
///   - teamPack: 战队信息，包含战队名和战队负责人
///   - completion: 执行回调，成功返回true
public func save(teamPack: [(team: String, manager: String)], completion: ExcuteCompletion?) {
    var count = 0
    for item in teamPack {
        save(team: item.team, manager: item.manager) { (isSuccess) in
            if isSuccess {
                count += 1
            }
        }
    }
    if count != teamPack.count {
        log(message: "****** shold save: \(teamPack.count) record, only save: \(count) record")
        completion?(false)
    }   else    {
        completion?(true)
    }
}

/// 删除战队，根据id
///
/// - Parameters:
///   - teamID:战队id
///   - completion: 执行回调，成功返回true
public func remove(teamID: Int, completion: ExcuteCompletion?) {
    let data = Team()
    do {
        try data.update(data: [("activeState", 0)], idValue: teamID)
        try data.get(teamID)
        log(message: "------ delete team: \(data.name), \(data.mananger), state: \(data.activeState)")
        completion?(true)
    } catch {
        print(error)
        log(error: error.localizedDescription)
        completion?(false)
    }
}

/// 批量删除战队，根据id
///
/// - Parameters:
///   - teamsID: 多个战队id，数组
///   - completion: 执行回调，成功返回true
public func remove(teamsID: [Int], completion: ExcuteCompletion?) {
    if teamsID.count <= 0 {
        completion?(true)
        return
    }
    
    for i in teamsID {
        let data = Team()
        do {
            try data.update(data: [("activeState", 0)], idValue: i)
            try data.get(i)
            log(message: "------ delete team: \(data.name), \(data.mananger), state: \(data.activeState)")
        } catch {
            print(error)
            log(error: error.localizedDescription)
            completion?(false)
            return
        }
    }
    
    completion?(true)
}

/// 删除战队，根据名称删除
///
/// - Parameters:
///   - zone: 战队名称
///   - completion: 执行回调，成功返回true
public func remove(teamName: String, completion: ExcuteCompletion?) {
    let data = Team()
    do {
        try data.find([("name", teamName), ("activeState", "1")])
        if data.id != 0 {
            let rows = data.rows()
            for row in rows {
                let oldValue = row.name
                row.activeState = 0
                try row.save()
                log(message: "------ delete team: \(oldValue)")
            }
            completion?(true)
        }   else    {
            completion?(false)
        }
    } catch {
        print(error)
        log(error: error.localizedDescription)
        completion?(false)
    }
}

/// 更新战队记录
///
/// - Parameters:
///   - team: 战队id
///   - value: 战队信息
///   - completion: 执行回调，成功返回true
public func update(team: Int, value: (team: String, manager: String), completion: ExcuteCompletion?) {
    let data = Team()
    do {
        try data.get(team)
        let oldName = data.name
        guard data.activeState > 0 else {
            log(message: "****** team: \(oldName) state is \(data.activeState)")
            completion?(false)
            return
        }
        data.name = value.team
        data.mananger = value.manager
        try data.save()
        log(message: ">>>>>> update team: \(oldName) -> \(data.name)")
        completion?(true)
    } catch {
        print(error)
        log(error: error.localizedDescription)
        completion?(false)
    }
}

/// 读取指定状态的战队数据，无排序
///
/// - Parameter teamState: 状态
/// - Returns: 战队数组数据
public func read(teamState: Int) -> [Team] {
    do {
        let zone = Team()
        try zone.find([("activeState", "\(teamState)")])
        return zone.rows()
    } catch {
        log(error: error.localizedDescription)
        return []
    }
}
