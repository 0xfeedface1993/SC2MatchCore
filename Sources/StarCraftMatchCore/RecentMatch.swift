//
//  RecentMatch.swift
//  PerfectTemplate
//
//  Created by virus1994 on 2019/4/24.
//

import StORM
import SQLiteStORM

public class Match: SQLiteStORM {
    public var id: Int = 0
    public var playera: Int = 0
    public var playerb: Int = 0
    public var type: Int = 0
    public var racea: String = ""
    public var raceb: String = ""
    public var page: String = ""
    public var event: String = ""
    public var utcTime: UInt32 = 0
    
    override open func table() -> String {
        return "current_match"
    }
    
    override public func to(_ this: StORMRow) {
        id = this.data["id"] as? Int ?? 0
        playera = this.data["playera"] as? Int ?? 0
        playerb = this.data["playerb"] as? Int ?? 0
        type = this.data["type"] as? Int ?? 0
        racea = this.data["racea"] as? String ?? ""
        raceb = this.data["raceb"] as? String ?? ""
        page = this.data["page"] as? String ?? ""
        event = this.data["event"] as? String ?? ""
        utcTime = this.data["utcTime"] as? UInt32 ?? 0
    }
    
    public func rows() -> [Match] {
        var rows = [Match]()
        for i in 0..<self.results.rows.count {
            let item = Match()
            item.to(self.results.rows[i])
            rows.append(item)
        }
        return rows
    }
}
