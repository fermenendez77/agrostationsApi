//
//  User.swift
//  App
//
//  Created by Fernando Menendez on 03/05/2020.
//

import Foundation
import FluentPostgreSQL
import Vapor
import Authentication

final class User : Codable {
    
    var id : UUID?
    var name : String
    var username : String
    var password : String
    
    init(name : String, username : String, password : String) {
        self.name = name
        self.username = username
        self.password = password
    }
    
    final class Public : Codable {
        var id : UUID?
        var name : String
        var username : String
        
        init(id: UUID?, name : String, username : String) {
            self.id = id
            self.name = name
            self.username = username
        }
    }
}

extension User {
    var stations : Children<User, Station> {
        return children(\.userId)
    }
}

extension User.Public : Content {}

extension User {
    func convertToPublic() -> User.Public {
        return User.Public(id: self.id,
                           name: self.name,
                           username: self.username)
    }
}

extension Future where T: User {
    func convertToPublic() -> Future<User.Public> {
        return self.map(to: User.Public.self) { user in
            return user.convertToPublic()
        }
    }
}

extension User : BasicAuthenticatable {
    static let usernameKey: UsernameKey = \User.username
    static let passwordKey: PasswordKey = \User.password
}

extension User : TokenAuthenticatable {
    typealias TokenType = Token
}

extension User : PostgreSQLUUIDModel {
    
    typealias Database = PostgreSQLDatabase
}
extension User : Content {}
extension User : Migration {}
extension User : Parameter {}
