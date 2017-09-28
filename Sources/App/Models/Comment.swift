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
    var post_id: Int
    
    
    // Use these keys instead of magic strings
    static let idKey = "id"
    static let contentKey = "content"
    static let post_idKey = "post_id"
    
    
    init(content: String,
         post_id: Int
        ) {
        self.content = content
        self.post_id = post_id
        
    }
    
    
    init(row: Row) throws {
        self.content = try row.get(Comment.contentKey)
        self.post_id = try row.get(Comment.post_idKey)
        
    }
    
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Comment.contentKey, content)
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
            // Need to research if is posible to use two foreign keys
            //comment.int(Comment.user_idKey)
            //comment.foreignId(for: User.self)
            comment.foreignId(for: Post.self)
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
                  post_id: try json.get(Comment.post_idKey)
        )}
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Comment.idKey, id)
        try json.set(Comment.contentKey, content)
        try json.set(Comment.post_idKey, post_id)
        return json
    }
}


extension Comment: Timestampable {}


// Convenience of returning response
extension Comment: ResponseRepresentable {}
