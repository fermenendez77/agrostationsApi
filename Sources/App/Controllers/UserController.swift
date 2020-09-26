//
//  UserController.swift
//  App
//
//  Created by Fernando Menendez on 10/05/2020.
//

import Foundation
import Vapor
import FluentPostgreSQL
import Crypto

struct UserController: RouteCollection {
    
    func boot(router: Router) throws {
        let usersRoute = router.grouped("api", "users")
        usersRoute.post(User.self, use: createHandler)
        usersRoute.get(User.parameter, use: getUserHandler)
        usersRoute.get(User.parameter, "stations", use : getStationsHandler)
        
        let basicAuthMiddleware = User.basicAuthMiddleware(using: BCryptDigest())
        let basicGrupAuth = usersRoute.grouped(basicAuthMiddleware)
        basicGrupAuth.post("login", use: loginHandler)
        basicGrupAuth.get(User.parameter, "stations", use : getStationsHandler)
    }
    
    // GET 
    func getUserHandler(_ req : Request) throws -> Future<User.Public> {
        return try req.parameters.next(User.self).convertToPublic()
    }
    
    // POST api/users/
    func createHandler(_ req: Request, user : User) throws -> Future<User.Public> {
        user.password = try BCrypt.hash(user.password)
        return user.save(on: req).convertToPublic()
    }
    
    // GET api/users/:USER_ID/stations
    func getStationsHandler(_ req : Request) throws -> Future<[Station]> {
        let user = try req.parameters.next(User.self)
        //let _ = try req.requireAuthenticated(User.self) 
        return user.flatMap(to: [Station].self) { user in
            return try user.stations.query(on: req).all()
        }
    }
    
    func loginHandler(_ req : Request) throws -> Future<Token> {
        let user = try req.requireAuthenticated(User.self)
        let token = try Token.generate(for: user)
        return token.save(on: req)
    }
}
