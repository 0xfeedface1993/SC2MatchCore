//
//  Zone.swift
//  StarCraftMatchCore
//
//  Created by virus1994 on 2019/4/10.
//

import StORM
import SQLiteStORM

/// 赛区
public class Zone: SQLiteStORM {
    public var id: Int = 0
    /// 赛区名
    public var name: String = ""
    /// 删除标记
    public var activeState: Int = 0
    
    override open func table() -> String {
        return "zone"
    }
    
    override public func to(_ this: StORMRow) {
        id = this.data["id"] as? Int ?? 0
        name = this.data["name"] as? String ?? ""
        activeState = this.data["activeState"] as? Int ?? 0
    }
    
    func rows() -> [Zone] {
        var rows = [Zone]()
        for i in 0..<self.results.rows.count {
            let item = Zone()
            item.to(self.results.rows[i])
            rows.append(item)
        }
        return rows
    }
}

/// 添加赛区，若存在相同名称的赛区则忽略
///
/// - Parameters:
///   - zone: 赛区名称
///   - completion: 执行回调，成功返回true
public func save(zone: String, completion: ExcuteCompletion?) {
    let data = Zone()
    data.name = zone
    do {
        try data.find([("name", zone)])
        data.activeState = 1
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

/// 添加批量赛区，若存在相同名称的赛区则忽略
///
/// - Parameters:
///   - zones: 赛区名称
///   - completion: 执行回调，成功返回true
public func save(zones: [String], completion: ExcuteCompletion?) {
    for item in zones {
        let data = Zone()
        data.name = item
        do {
            try data.find([("name", item)])
            data.activeState = 1
            try data.save(set: { (id) in
                data.id = id as! Int
            })
            log(message: ">>>>>> update zone: \(data.name), state: \(data.activeState)")
        } catch {
            print(error)
            log(error: error.localizedDescription)
            completion?(false)
            break
        }
    }
    
    completion?(true)
}

/// 删除赛区，根据id删除
///
/// - Parameters:
///   - zone: 赛区ID
///   - completion: 执行回调，成功返回true
public func remove(zoneID: Int, completion: ExcuteCompletion?) {
    let data = Zone()
    do {
        try data.update(data: [("activeState", 0)], idValue: zoneID)
        try data.get(zoneID)
        log(message: "------ delete zone: \(data.name), state: \(data.activeState)")
        completion?(true)
    } catch {
        print(error)
        log(error: error.localizedDescription)
        completion?(false)
    }
}

/// 删除多个赛区，根据id删除
///
/// - Parameters:
///   - zonesID: 多个赛区ID
///   - completion: 执行回调，成功返回true
public func remove(zonesID: [Int], completion: ExcuteCompletion?) {
    if zonesID.count <= 0 {
        completion?(true)
        return
    }
    for i in zonesID {
        let data = Zone()
        do {
            try data.update(data: [("activeState", 0)], idValue: i)
            try data.get(i)
            log(message: "------ delete zone: \(data.name), state: \(data.activeState)")
        } catch {
            print(error)
            log(error: error.localizedDescription)
            completion?(false)
            return
        }
    }
    completion?(true)
}

/// 删除赛区，根据名称删除
///
/// - Parameters:
///   - zone: 赛区名称
///   - completion: 执行回调，成功返回true
public func remove(zoneName: String, completion: ExcuteCompletion?) {
    let data = Zone()
    do {
        try data.find([("name", zoneName), ("activeState", "1")])
        if data.id != 0 {
            let rows = data.rows()
            for row in rows {
                let oldValue = row.name
                row.activeState = 0
                try row.save()
                log(message: "------ delete zone: \(oldValue)")
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

/// 更新赛区名
///
/// - Parameters:
///   - zone: 赛区id
///   - name: 新赛区名
///   - completion: 执行回调，成功返回true
public func update(zone: Int, name: String, completion: ExcuteCompletion?) {
    let data = Zone()
    do {
        try data.get(zone)
        let oldName = data.name
        guard data.activeState > 0 else {
            log(message: "****** zone: \(oldName) state is \(data.activeState)")
            completion?(false)
            return
        }
        data.name = name
        try data.save()
        log(message: ">>>>>> update zone: \(oldName) -> \(data.name)")
        completion?(true)
    } catch {
        print(error)
        log(error: error.localizedDescription)
        completion?(false)
    }
}


/// 读取指定状态的赛区数据，无排序
///
/// - Parameter zoneState: 有效状态，1为有效状态
/// - Returns: 赛区数据数组
public func read(zoneState: Int) -> [Zone] {
    do {
        let zone = Zone()
        try zone.find([("activeState", "\(zoneState)")])
        return zone.rows()
    } catch {
        log(error: error.localizedDescription)
        return []
    }
}
