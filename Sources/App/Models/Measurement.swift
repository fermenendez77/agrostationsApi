//
//  Measurement.swift
//  App
//
//  Created by Fernando Menendez on 11/05/2020.
//

import Foundation
import FluentMySQL
import Vapor

final class Measurement : Codable {
    
    var id : Int?
    var groundWaterDistinace : Double?
    var groundTemperature : Double?
    var windVelocity : Double?
    var windDirection : String?
    var humidity : Double?
    var stationId : Station.ID
    var measurementDate : Date
    
    init(groundWaterDistance : Double?, groundTemperature : Double?,
         windVelocity : Double?, windDirection: String?,
         humidity : Double?, stationId : Station.ID, date : Date) {
        
        self.groundWaterDistinace = groundWaterDistance
        self.groundTemperature = groundTemperature
        self.windVelocity = windVelocity
        self.windDirection = windDirection
        self.humidity = humidity
        self.stationId = stationId
        self.measurementDate = date
    }
    
    var station : Parent<Measurement, Station> {
        return parent(\.stationId)
    }
}

extension Measurement : MySQLModel {}
extension Measurement : Content {}
extension Measurement : Migration {}
extension Measurement : Parameter {}

struct MeasurementCreateData : Content {
    
    var groundWaterDistinace : Double?
    var groundTemperature : Double?
    var windVelocity : Double?
    var windDirection : String?
    var humidity : Double?
}
