//
//  PostGresDB.swift
//  StarCraftMatchCore
//
//  Created by virus1994 on 2019/5/6.
//

import Foundation
import PerfectLib
import StORM
import PostgresStORM

public func configurePostgresDB() {
    PostgresConnector.host        = "localhost"
    PostgresConnector.username    = ""
    PostgresConnector.password    = ""
    PostgresConnector.database    = ""
    PostgresConnector.port        = 5432
}

public protocol MatchResultX: Codable {
    
}

public class PPlayer: PostgresStORM {
    public struct PlayerResult : MatchResultX {
        public var id: Int
        public var tag: String
        public var birthday: Date?
        public var mcnum: Int
        public var tlpd_id: Int
        public var tlpd_db: Int
        public var lp_name: String
        public var sc2e_id: Int
        public var country: String
        public var dom_val: Float64
        public var dom_start_id: Int
        public var dom_end_id: Int
        public var current_rating_id: Int
        public var romanized_name: String
    }
    public var id: Int = 0
    public var tag: String = ""
    public var birthday: Date?
    public var mcnum: Int = 0
    public var tlpd_id: Int = 0
    public var tlpd_db: Int = 0
    public var lp_name: String = ""
    public var sc2e_id: Int = 0
    public var country: String = ""
    public var dom_val: Float64 = 0
    public var dom_start_id: Int = 0
    public var dom_end_id: Int = 0
    public var current_rating_id: Int = 0
    public var romanized_name: String = ""
    
    override open func table() -> String {
        return "player"
    }
    
    override public func to(_ this: StORMRow) {
        id = this.data["id"] as? Int ?? 0
        tag = this.data["tag"] as? String ?? ""
        mcnum = this.data["mcnum"] as? Int ?? 0
        birthday = this.data["birthday"] as? Date
        tlpd_id = this.data["tlpd_id"] as? Int ?? 0
        tlpd_db = this.data["tlpd_db"] as? Int ?? 0
        lp_name = this.data["lp_name"] as? String ?? ""
        sc2e_id = this.data["sc2e_id"] as? Int ?? 0
        country = this.data["country"] as? String ?? ""
        dom_val = this.data["dom_val"] as? Float64 ?? 0
        dom_start_id = this.data["dom_start_id"] as? Int ?? 0
        dom_end_id = this.data["dom_end_id"] as? Int ?? 0
        current_rating_id = this.data["current_rating_id"] as? Int ?? 0
        romanized_name = this.data["romanized_name"] as? String ?? ""
    }
    
    public func rows() -> [PPlayer] {
        var rows = [PPlayer]()
        for i in 0..<self.results.rows.count {
            let item = PPlayer()
            item.to(self.results.rows[i])
            rows.append(item)
        }
        return rows
    }
    
    public func transformResult() -> PlayerResult {
        return PlayerResult(id: self.id,
                            tag: self.tag,
                            birthday: self.birthday,
                            mcnum: self.mcnum,
                            tlpd_id: self.tlpd_id,
                            tlpd_db: self.tlpd_db,
                            lp_name: self.lp_name,
                            sc2e_id: self.sc2e_id,
                            country: self.country,
                            dom_val: self.dom_val,
                            dom_start_id: self.dom_start_id,
                            dom_end_id: self.dom_end_id,
                            current_rating_id: self.current_rating_id,
                            romanized_name: self.romanized_name)
    }
}

public class PGroup: PostgresStORM {
    public struct GroupResult: MatchResultX {
        public var id: Int
        public var name: String
        public var shortname: String
        public var scoreak: Float64
        public var scorepl: Float64
        public var founded: Date?
        public var disbanded: Date?
        public var active: Bool
        public var homepage: String
        public var lp_name: String
        public var is_team: Bool
        public var is_manual: Bool
        public var meanrating: Float64
    }
    public var id: Int = 0
    public var name: String = ""
    public var shortname: String = ""
    public var scoreak: Float64 = 0
    public var scorepl: Float64 = 0
    public var founded: Date?
    public var disbanded: Date?
    public var active: Bool = false
    public var homepage: String = ""
    public var lp_name: String = ""
    public var is_team: Bool = false
    public var is_manual: Bool = false
    public var meanrating: Float64 = 0
    
    override open func table() -> String {
        return "\"group\""
    }
    
    override public func to(_ this: StORMRow) {
        id = this.data["id"] as? Int ?? 0
        name = this.data["name"] as? String ?? ""
        shortname = this.data["shortname"] as? String ?? ""
        scoreak = this.data["scoreak"] as? Float64 ?? 0
        scorepl = this.data["scorepl"] as? Float64 ?? 0
        founded = this.data["founded"] as? Date
        disbanded = this.data["disbanded"] as? Date
        active = this.data["active"] as? Bool ?? false
        homepage = this.data["homepage"] as? String ?? ""
        lp_name = this.data["lp_name"] as? String ?? ""
        is_team = this.data["is_team"] as? Bool ?? false
        is_manual = this.data["is_manual"] as? Bool ?? false
        meanrating = this.data["meanrating"] as? Float64 ?? 0
    }
    
    public func rows() -> [PGroup] {
        var rows = [PGroup]()
        for i in 0..<self.results.rows.count {
            let item = PGroup()
            item.to(self.results.rows[i])
            rows.append(item)
        }
        return rows
    }
    
    public func transformResult() -> GroupResult {
        return GroupResult(id: self.id,
                           name: self.name,
                           shortname: self.shortname,
                           scoreak: self.scoreak,
                           scorepl: self.scorepl,
                           founded: self.founded,
                           disbanded: self.disbanded,
                           active: self.active,
                           homepage: self.homepage,
                           lp_name: self.lp_name,
                           is_team: self.is_team,
                           is_manual: self.is_manual,
                           meanrating: self.meanrating)
    }
}

public class PEvent: PostgresStORM {
    public var id: Int = 0
    public var name: String = ""
    public var parent_id: Int = 0
    public var lft: Int = 0
    public var rgt: Int = 0
    public var closed: Bool = false
    public var big: Bool = false
    public var noprint: Bool = false
    public var fullname: String = ""
    public var homepage: String = ""
    public var lp_name: String = ""
    public var tlpd_id: Int = 0
    public var tlpd_db: Int = 0
    public var tl_thread: Int = 0
    public var prizepool: Bool = false
    public var earliest: Date?
    public var latest: Date?
    public var category: String = ""
    public var type: String = ""
    public var idx: Int = 0
    public var wcs_year: Int = 0
    public var wcs_tier: Int = 0
    
    override open func table() -> String {
        return "event"
    }
    
    override public func to(_ this: StORMRow) {
        id = this.data["id"] as? Int ?? 0
        name = this.data["name"] as? String ?? ""
        parent_id = this.data["parent_id"] as? Int ?? 0
        lft = this.data["lft"] as? Int ?? 0
        rgt = this.data["rgt"] as? Int ?? 0
        closed = this.data["closed"] as? Bool ?? false
        big = this.data["big"] as? Bool ?? false
        noprint = this.data["noprint"] as? Bool ?? false
        fullname = this.data["fullname"] as? String ?? ""
        homepage = this.data["homepage"] as? String ?? ""
        lp_name = this.data["lp_name"] as? String ?? ""
        tlpd_id = this.data["tlpd_id"] as? Int ?? 0
        tlpd_db = this.data["tlpd_db"] as? Int ?? 0
        tl_thread = this.data["tl_thread"] as? Int ?? 0
        prizepool = this.data["prizepool"] as? Bool ?? false
        earliest = this.data["earliest"] as? Date
        latest = this.data["latest"] as? Date
        category = this.data["category"] as? String ?? ""
        type = this.data["type"] as? String ?? ""
        idx = this.data["idx"] as? Int ?? 0
        wcs_year = this.data["wcs_year"] as? Int ?? 0
        wcs_tier = this.data["wcs_tier"] as? Int ?? 0
    }
    
    public func rows() -> [PEvent] {
        var rows = [PEvent]()
        for i in 0..<self.results.rows.count {
            let item = PEvent()
            item.to(self.results.rows[i])
            rows.append(item)
        }
        return rows
    }
}

public func readTop10Player() {
    let data = PPlayer()
    do {
        try data.findAll()
        data.rows().forEach({
            print(">>>?>>> \($0.birthday), \($0.tag)")
        })
    } catch {
        log(error: error.localizedDescription)
    }
}

public func find(player: String, race: String, nation: String) -> PPlayer? {
    let data = PPlayer()
    do {
        try data.find([("tag", player), ("race", race), ("country", nation)])
        print(">>>>>> plyer id: \(data.id), tag: \(data.tag)")
        return data
    } catch {
        log(error: error.localizedDescription)
        return nil
    }
}

public func find(team: String, lpname: String) -> PGroup? {
    let data = PGroup()
    if team.isEmpty, team.isEmpty {
        return nil
    }
    
    var whereclause : String!
    var params = [String]()
    
    if team.isEmpty {
        whereclause = "name = $1 or shortname = $1"
        params = [lpname]
    } else if lpname.isEmpty {
        whereclause = "name = $1 or shortname = $1"
        params = [team]
    }   else    {
        whereclause = "name = $1 or name = $2 or shortname = $2 or shortname = $1 or lp_name = $1 or lp_name = $2"
        params = [lpname, team]
    }
    
    do {
        try data.select(whereclause: whereclause, params: params, orderby: ["name"])
        print(">>>>>> team id: \(data.id), name: \(data.name)")
        return data
    } catch {
        log(error: error.localizedDescription)
        return nil
    }
}

public func find(eventname: String) -> PEvent? {
    let data = PEvent()
    do {
        print("<<<<<< \(eventname)")
        try data.find([("fullname", eventname)])
        print(">>>?>>> \(data.id), \(data.fullname) \(data.name)")
        return data
    } catch {
        log(error: error.localizedDescription)
        return nil
    }
}
