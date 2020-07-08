//
//  Station.swift
//  App
//
//  Created by Fernando Menendez on 10/05/2020.
//

import Foundation
import FluentMySQL
import Vapor

final class Station : Codable {
    
    var id : Int?
    var userId : User.ID
    var lat : Double
    var lon : Double
    var name : String
    var lastUpdate : Date
    
    init(userId : User.ID, lat : Double, lon : Double, name : String, lastUpdate : Date) {
        self.userId = userId
        self.lat = lat
        self.lon = lon
        self.name = name
        self.lastUpdate = lastUpdate
    }
    
    var user : Parent<Station, User> {
        return parent(\.userId)
    }
    
    var measurements : Children<Station, Measurement> {
        return children(\.stationId)
    }
}

extension Station : MySQLModel {}
extension Station : Content {}
extension Station : Migration {}
extension Station : Parameter {}

struct StationCreateData : Content {
    
    let lat : Double
    let lon : Double
    let name : String
}

enum StationStatus : String, Content {
    case active
    case inactive
    case error
}


