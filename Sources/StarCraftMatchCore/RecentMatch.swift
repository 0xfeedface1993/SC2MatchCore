//
//  RecentMatch.swift
//  PerfectTemplate
//
//  Created by virus1994 on 2019/4/24.
//

import StORM
import SQLiteStORM

//public class Match: APIRequest {
//    public var id: Int = 0
//    public var namea: String = ""
//    public var nameb: String = ""
//    public var type: Int = 0
//    public var racea: Int = 0
//    public var raceb: Int = 0
//    public var nationa: String = ""
//    public var nationb: String = ""
//    
//    
//    /// 负责人（默认经理）
//    public var mananger: String = ""
//    /// 删除标记
//    public var activeState: Int = 0
//    
//    override open func table() -> String {
//        return "team"
//    }
//    
//    override public func to(_ this: StORMRow) {
//        id = this.data["id"] as? Int ?? 0
//        name = this.data["name"] as? String ?? ""
//        mananger = this.data["mananger"] as? String ?? ""
//        activeState = this.data["activeState"] as? Int ?? 0
//    }
//    
//    func rows() -> [Team] {
//        var rows = [Team]()
//        for i in 0..<self.results.rows.count {
//            let item = Team()
//            item.to(self.results.rows[i])
//            rows.append(item)
//        }
//        return rows
//    }
//}
