//
//  Comment.swift
//  traxapi
//
//  Created by Mugurel Moscaliuc on 23/09/2017.
//
//

import PostgreSQLProvider

final class PostComment: Model {
    
    let storage = Storage()
    var content: String
    var post_id: Int
    
    
    // Use these keys instead of magic strings
    static let idKey = "id"
    static let contentKey = "content"
    static let post_idKey = "post_id"
    static let user_idKey = "user_id"
    
    
    init(content: String,
         post_id: Int
        ) {
        self.content = content
        self.post_id = post_id
        
    }
    
    
    init(row: Row) throws {
        self.content = try row.get(PostComment.contentKey)
        self.post_id = try row.get(PostComment.post_idKey)
        
    }
    
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(PostComment.contentKey, content)
        try row.set(PostComment.post_idKey, post_id)
        return row
    }
}
// For database prepare and revert
extension PostComment: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create(self) { (builder) in
            builder.id()
            builder.string(PostComment.contentKey)
            builder.int(PostComment.user_idKey)
            builder.foreignId(for: Post.self)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

// Convenience of generate model from JSON
extension PostComment: JSONConvertible {
    
    convenience init(json: JSON) throws {
        self.init(content: try json.get(PostComment.contentKey),
                  post_id: try json.get(PostComment.post_idKey)
        )}
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(PostComment.idKey, id)
        try json.set(PostComment.contentKey, content)
        try json.set(PostComment.post_idKey, post_id)
        return json
    }
}


extension PostComment: Timestampable {}


// Convenience of returning response
extension PostComment: ResponseRepresentable {}
