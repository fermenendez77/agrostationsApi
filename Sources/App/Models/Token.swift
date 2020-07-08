//
//  Token.swift
//  App
//
//  Created by Fernando Menendez on 04/05/2020.
//

import Foundation
import Vapor
import FluentMySQL
import Crypto
import Authentication

final class Token : Codable {
    var id : UUID?
    var token : String
    var userId : User.ID
    
    init(token : String, userId : User.ID) {
        self.token = token
        self.userId = userId
    }

}

extension Token : MySQLUUIDModel {}
extension Token : Content {}
extension Token : Migration {}

extension Token {
    var user : Parent<Token, User> {
        return parent(\.userId)
    }
}

extension Token {
    static func generate(for user : User) throws -> Token {
        let random = try CryptoRandom().generateData(count: 16)
        return try Token(token: random.base64EncodedString(), userId: user.requireID())
    }
}

extension Token : Authentication.Token {
    
    static let userIDKey: UserIDKey = \Token.userId
    typealias UserType = User
}

extension Token : BearerAuthenticatable {
    static let tokenKey : TokenKey = \Token.token
}

