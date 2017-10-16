//
//  PostLike.swift
//  traxapi
//
//  Created by Mugurel Moscaliuc on 06/10/2017.
//
//

import PostgreSQLProvider

final class PostLike: Model {
    
    let storage = Storage()
    var user_id: Int
    var post_id: Int
    
    
    // Use these keys instead of magic strings
    static let idKey = "id"
    static let user_idKey = "user_id"
    static let post_idKey = "post_id"
    
    
    init(user_id: Int,
         post_id: Int
        ) {
        self.user_id = user_id
        self.post_id = post_id
    }
    
    
    init(row: Row) throws {
        self.user_id = try row.get(PostLike.user_idKey)
        self.post_id = try row.get(PostLike.post_idKey)
        
    }
    
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(PostLike.user_idKey, user_id)
        try row.set(PostLike.post_idKey, post_id)
        return row
    }
}
// For database prepare and revert
extension PostLike: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create(self) { (builder) in
            builder.id()
            //builder.int(PostLike.user_idKey)
            builder.parent(User.self, optional: false)
            builder.foreignId(for: Post.self)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

// Convenience of generate model from JSON
extension PostLike: JSONConvertible {
    
    convenience init(json: JSON) throws {
        self.init(user_id: try json.get(PostLike.user_idKey),
                  post_id: try json.get(PostLike.post_idKey)
        )}
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(PostLike.idKey, id)
        try json.set(PostLike.post_idKey, post_id)
        return json
    }
}




// Convenience of returning response
extension PostLike: ResponseRepresentable {}
