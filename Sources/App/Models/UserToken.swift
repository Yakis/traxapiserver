//
//  Token.swift
//  traxapi
//
//  Created by Mugurel Moscaliuc on 23/09/2017.
//
//

import PostgreSQLProvider

final class UserToken: Model {
    
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
        self.token = try row.get(UserToken.tokenKey)
        self.user_id = try row.get(UserToken.user_idKey)
        
    }
    
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(UserToken.tokenKey, token)
        try row.set(UserToken.user_idKey, user_id)
        return row
    }
}
// For database prepare and revert
extension UserToken: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create(self) { (builder) in
            builder.id()
            builder.string(UserToken.tokenKey)
            builder.foreignId(for: User.self)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

// Convenience of generate model from JSON
extension UserToken: JSONConvertible {
    
    convenience init(json: JSON) throws {
        self.init(token: try json.get(UserToken.tokenKey),
                  user_id: try json.get(UserToken.user_idKey)
        )}
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(UserToken.idKey, id)
        try json.set(UserToken.tokenKey, token)
        try json.set(UserToken.user_idKey, user_id)
        return json
    }
}

// Convenience of returning response
extension UserToken: ResponseRepresentable {}
