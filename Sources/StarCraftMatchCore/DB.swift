//
//  DB.swift
//  COpenSSL
//
//  Created by virus1994 on 2019/4/9.
//

import StORM
import SQLiteStORM

/// 初始化数据库
func configDatabase() {
    let team = Team()
    let zone = Zone()
    let teamInZone = TeamInZone()
    do {
        try team.setupTable()
        try zone.setupTable()
        try teamInZone.setupTable()
    } catch {
        print(error)
    }
    
}

/// 删除该表每一条数据记录
///
/// - Parameter record: 表ORM实例，初始化的对象即可
func deleteAll<T: SQLiteStORM>(record: T) {
    let data = record
    do {
        try data.findAll()
        data.results.rows.map({ $0.id() as? Int ?? 0 }).filter({ $0 != 0 }).forEach({
            do {
                try data.delete($0)
            }   catch   {
                log(error: error.localizedDescription)
            }
        })
        log(message: "****** delete all \(T.self)")
    } catch {
        log(error: error.localizedDescription)
    }
    
}
