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
    var user_id: Int
    
    
    // Use these keys instead of magic strings
    static let idKey = "id"
    static let contentKey = "content"
    static let post_idKey = "post_id"
    static let user_idKey = "user_id"
    
    
    init(content: String,
         post_id: Int, user_id: Int
        ) {
        self.content = content
        self.post_id = post_id
        self.user_id = user_id
        
    }
    
    
    init(row: Row) throws {
        self.content = try row.get(PostComment.contentKey)
        self.post_id = try row.get(PostComment.post_idKey)
        self.user_id = try row.get(PostComment.user_idKey)
        
    }
    
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(PostComment.contentKey, content)
        try row.set(PostComment.post_idKey, post_id)
        try row.set(PostComment.user_idKey, user_id)
        return row
    }
}
// For database prepare and revert
extension PostComment: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create(self) { (builder) in
            builder.id()
            builder.string(PostComment.contentKey, length: 1500)
            //builder.int(PostComment.user_idKey)
            builder.parent(User.self, optional: false)
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
                  post_id: try json.get(PostComment.post_idKey),
                  user_id: try json.get(PostComment.user_idKey)
        )}
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(PostComment.idKey, id)
        try json.set(PostComment.contentKey, content)
        try json.set(PostComment.post_idKey, post_id)
        try json.set(PostComment.user_idKey, user_id)
        try json.set(PostComment.createdAtKey, self.formattedCreatedAt)
        try json.set(PostComment.updatedAtKey, self.formattedUpdatedAt)
        return json
    }
}


extension PostComment: Timestampable {}


// Convenience of returning response
extension PostComment: ResponseRepresentable {}


extension PostComment {
    
    var replies: Children<PostComment, PostReply> {
        return children()
    }
    
    
}
