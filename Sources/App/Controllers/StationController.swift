//
//  StationController.swift
//  App
//
//  Created by Fernando Menendez on 10/05/2020.
//

import Foundation
import Vapor
import FluentMySQL
import Crypto

struct StationController : RouteCollection {
    
    func boot(router: Router) throws {
        
        let stationsRoute = router.grouped("api", "stations")
        
        stationsRoute.post(MeasurementCreateData.self,
                           at: Station.parameter,
                           use: addMeaserumentHandler)
        
        stationsRoute.get(Station.parameter, use: getStationHandler)
        stationsRoute.get(Station.parameter, "measurements", use: getMeasurementsHandler)
        
        let tokenAuthMiddleware = User.tokenAuthMiddleware()
        let guardMiddleware = User.guardAuthMiddleware()
        let tokenGroup = stationsRoute.grouped(tokenAuthMiddleware, guardMiddleware)
        
        tokenGroup.post(StationCreateData.self, use: createHandler)
    }
    
    func createHandler(_ req: Request, acronymData : StationCreateData) throws -> Future<Station> {
        let user = try req.requireAuthenticated(User.self)
        let date = Date()
        let station = try Station(userId: user.requireID(),
                                  lat: acronymData.lat,
                                  lon: acronymData.lon,
                                  name: acronymData.name,
                                  lastUpdate: date)
        return station.save(on: req)
    }
    
    func addMeaserumentHandler(_ req: Request, measerumentData : MeasurementCreateData)
            throws -> Future<Measurement> {
        return try req.parameters.next(Station.self)
            .flatMap(to: Measurement.self) { station in
                let measurement =
                    try Measurement(groundWaterDistance: measerumentData.groundWaterDistinace,
                                    groundTemperature: measerumentData.groundTemperature,
                                    windVelocity: measerumentData.windVelocity,
                                    windDirection: measerumentData.windDirection,
                                    humidity: measerumentData.humidity,
                                    stationId: station.requireID(), date: Date())
                let date = Date()
                station.lastUpdate = date
                let _ = station.save(on: req)
                return measurement.save(on: req)
        }
    }
    
    func getMeasurementsHandler(_ req : Request) throws -> Future<[Measurement]> {
        return try req.parameters.next(Station.self)
            .flatMap(to: [Measurement].self) { station in
                return try station.measurements.query(on: req).all()
        }
    }
    
    func getStationHandler(_ req: Request) throws -> Future<Station> {
        return try req.parameters.next(Station.self)
    }
}
