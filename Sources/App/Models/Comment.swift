//
//  Comment.swift
//  traxapi
//
//  Created by Mugurel Moscaliuc on 23/09/2017.
//
//

import PostgreSQLProvider

final class Comment: Model {
    
    let storage = Storage()
    var content: String
    var timestamp: String
    var user_id: Int
    var post_id: Int
    
    
    // Use these keys instead of magic strings
    static let idKey = "id"
    static let contentKey = "content"
    static let timestampKey = "timestamp"
    static let user_idKey = "user_id"
    static let post_idKey = "post_id"
    
    
    init(content: String,
         timestamp: String,
         user_id: Int,
         post_id: Int
        ) {
        self.content = content
        self.timestamp = timestamp
        self.user_id = user_id
        self.post_id = post_id
        
    }
    
    
    init(row: Row) throws {
        self.content = try row.get(Comment.contentKey)
        self.timestamp = try row.get(Comment.timestampKey)
        self.user_id = try row.get(Comment.user_idKey)
        self.post_id = try row.get(Comment.post_idKey)
        
    }
    
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Comment.contentKey, content)
        try row.set(Comment.timestampKey, timestamp)
        try row.set(Comment.user_idKey, user_id)
        try row.set(Comment.post_idKey, post_id)
        return row
    }
}
// For database prepare and revert
extension Comment: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create(self) { (comment) in
            comment.id()
            comment.string(Comment.contentKey)
            comment.string(Comment.timestampKey)
            comment.int(Comment.user_idKey)
            comment.int(Comment.post_idKey)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

// Convenience of generate model from JSON
extension Comment: JSONConvertible {
    
    convenience init(json: JSON) throws {
        self.init(content: try json.get(Comment.contentKey),
                timestamp: try json.get(Comment.timestampKey),
                  user_id: try json.get(Comment.user_idKey),
                  post_id: try json.get(Comment.post_idKey)
        )}
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Comment.idKey, id)
        try json.set(Comment.contentKey, content)
        try json.set(Comment.timestampKey, timestamp)
        try json.set(Comment.user_idKey, user_id)
        try json.set(Comment.post_idKey, post_id)
        return json
    }
}

// Convenience of returning response
extension Comment: ResponseRepresentable {}
