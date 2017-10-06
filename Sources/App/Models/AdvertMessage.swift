//
//  AdvertMessage.swift
//  traxapi
//
//  Created by Mugurel Moscaliuc on 06/10/2017.
//
//

import PostgreSQLProvider

final class AdvertMessage: Model {
    
    let storage = Storage()
    var content: String
    var user_id: Int
    
    
    // Use these keys instead of magic strings
    static let idKey = "id"
    static let contentKey = "content"
    static let post_idKey = "post_id"
    static let user_idKey = "user_id"
    
    
    init(content: String,
         user_id: Int
        ) {
        self.content = content
        self.user_id = user_id
        
    }
    
    
    init(row: Row) throws {
        self.content = try row.get(AdvertMessage.contentKey)
        self.user_id = try row.get(AdvertMessage.user_idKey)
        
    }
    
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(AdvertMessage.contentKey, content)
        try row.set(AdvertMessage.user_idKey, user_id)
        return row
    }
}
// For database prepare and revert
extension AdvertMessage: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create(self) { (builder) in
            builder.id()
            builder.string(AdvertMessage.contentKey)
            builder.int(AdvertMessage.user_idKey)
            builder.foreignId(for: Advert.self)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

// Convenience of generate model from JSON
extension AdvertMessage: JSONConvertible {
    
    convenience init(json: JSON) throws {
        self.init(content: try json.get(AdvertMessage.contentKey),
                  user_id: try json.get(AdvertMessage.user_idKey)
        )}
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(AdvertMessage.idKey, id)
        try json.set(AdvertMessage.contentKey, content)
        try json.set(AdvertMessage.user_idKey, user_id)
        return json
    }
}


extension AdvertMessage: Timestampable {}


// Convenience of returning response
extension AdvertMessage: ResponseRepresentable {}
