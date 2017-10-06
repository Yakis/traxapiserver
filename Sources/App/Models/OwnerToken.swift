//
//  OwnerToken.swift
//  traxapi
//
//  Created by Mugurel Moscaliuc on 06/10/2017.
//
//

import PostgreSQLProvider

final class OwnerToken: Model {
    
    let storage = Storage()
    var token: String
    var owner_id: Int
    
    
    // Use these keys instead of magic strings
    static let idKey = "id"
    static let tokenKey = "token"
    static let owner_idKey = "owner_id"
    
    
    init(token: String,
         owner_id: Int
        ) {
        self.token = token
        self.owner_id = owner_id
        
    }
    
    
    init(row: Row) throws {
        self.token = try row.get(OwnerToken.tokenKey)
        self.owner_id = try row.get(OwnerToken.owner_idKey)
        
    }
    
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(OwnerToken.tokenKey, token)
        try row.set(OwnerToken.owner_idKey, owner_id)
        return row
    }
}
// For database prepare and revert
extension OwnerToken: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create(self) { (builder) in
            builder.id()
            builder.string(OwnerToken.tokenKey)
            builder.foreignId(for: Owner.self)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

// Convenience of generate model from JSON
extension OwnerToken: JSONConvertible {
    
    convenience init(json: JSON) throws {
        self.init(token: try json.get(OwnerToken.tokenKey),
                  owner_id: try json.get(OwnerToken.owner_idKey)
        )}
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(OwnerToken.idKey, id)
        try json.set(OwnerToken.tokenKey, token)
        try json.set(OwnerToken.owner_idKey, owner_id)
        return json
    }
}

// Convenience of returning response
extension OwnerToken: ResponseRepresentable {}
