//
//  Token.swift
//  traxapi
//
//  Created by Mugurel Moscaliuc on 23/09/2017.
//
//

import PostgreSQLProvider

final class Token: Model {
    
    let storage = Storage()
    var token: String
    var user_id: Int
    
    
    // Use these keys instead of magic strings
    static let idKey = "id"
    static let tokenKey = "token"
    static let user_idKey = "user_id"
    
    
    init(token: String,
         user_id: Int
        ) {
        self.token = token
        self.user_id = user_id
        
    }
    
    
    init(row: Row) throws {
        self.token = try row.get(Token.tokenKey)
        self.user_id = try row.get(Token.user_idKey)
        
    }
    
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Token.tokenKey, token)
        try row.set(Token.user_idKey, user_id)
        return row
    }
}
// For database prepare and revert
extension Token: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create(self) { (token) in
            token.id()
            token.string(Token.tokenKey)
            token.foreignId(for: User.self)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

// Convenience of generate model from JSON
extension Token: JSONConvertible {
    
    convenience init(json: JSON) throws {
        self.init(token: try json.get(Token.tokenKey),
                  user_id: try json.get(Token.user_idKey)
        )}
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Token.idKey, id)
        try json.set(Token.tokenKey, token)
        try json.set(Token.user_idKey, user_id)
        return json
    }
}

// Convenience of returning response
extension Token: ResponseRepresentable {}
