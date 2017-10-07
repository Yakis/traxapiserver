//
//  PostReply.swift
//  traxapi
//
//  Created by Mugurel Moscaliuc on 06/10/2017.
//
//

import PostgreSQLProvider

final class PostReply: Model {
    
    let storage = Storage()
    var content: String
    var post_comment_id: Int
    
    
    // Use these keys instead of magic strings
    static let idKey = "id"
    static let contentKey = "content"
    static let post_comment_idKey = "post_comment_id"
    static let user_idKey = "user_id"
    
    
    init(content: String,
         post_comment_id: Int
        ) {
        self.content = content
        self.post_comment_id = post_comment_id
        
    }
    
    
    init(row: Row) throws {
        self.content = try row.get(PostReply.contentKey)
        self.post_comment_id = try row.get(PostReply.post_comment_idKey)
        
    }
    
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(PostReply.contentKey, content)
        try row.set(PostReply.post_comment_idKey, post_comment_id)
        return row
    }
}
// For database prepare and revert
extension PostReply: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create(self) { (builder) in
            builder.id()
            builder.string(PostReply.contentKey)
            //builder.int(PostReply.user_idKey)
            builder.parent(User.self, optional: false)
            builder.foreignId(for: PostComment.self)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

// Convenience of generate model from JSON
extension PostReply: JSONConvertible {
    
    convenience init(json: JSON) throws {
        self.init(content: try json.get(PostReply.contentKey),
                  post_comment_id: try json.get(PostReply.post_comment_idKey)
        )}
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(PostReply.idKey, id)
        try json.set(PostReply.contentKey, content)
        try json.set(PostReply.post_comment_idKey, post_comment_id)
        return json
    }
}


extension PostReply: Timestampable {}


// Convenience of returning response
extension PostReply: ResponseRepresentable {}
