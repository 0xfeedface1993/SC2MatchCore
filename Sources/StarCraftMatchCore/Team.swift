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
    var id: Int = 0
    /// 名称
    var name: String = ""
    /// 负责人（默认经理）
    var mananger: String = ""
    /// 删除标记
    var activeState: Int = 0
    
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
