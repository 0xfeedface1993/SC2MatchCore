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

public class PPlayer: PostgresStORM {
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
}

public class PGroup: PostgresStORM {
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
        print(">>>?>>> \(data.id), \(data.tag)")
        return data
    } catch {
        log(error: error.localizedDescription)
        return nil
    }
}

public func find(team: String, lpname: String) -> PGroup? {
    let data = PGroup()
    do {
        try data.select(whereclause: "name = $1 or name = $2 or shortname = $2 or shortname = $1 or lp_name = $1 or lp_name = $2", params: [lpname, team], orderby: ["name"])
        print(">>>?>>> \(data.id), \(data.name)")
        return data
    } catch {
        log(error: error.localizedDescription)
        return nil
    }
}
