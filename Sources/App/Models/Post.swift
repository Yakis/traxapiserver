//
//  Post.swift
//  traxapi
//
//  Created by Mugurel Moscaliuc on 23/09/2017.
//
//

import PostgreSQLProvider

final class Post: Model {
    
    let storage = Storage()
    var content: String
    var image: String
    var track_id: Int
    
    
    // Use these keys instead of magic strings
    static let idKey = "id"
    static let contentKey = "content"
    static let imageKey = "image"
    static let track_idKey = "track_id"
    
    
    init(content: String,
         image: String,
         track_id: Int
        ) {
        self.content = content
        self.image = image
        self.track_id = track_id
        
    }
    
    
    init(row: Row) throws {
        self.content = try row.get(Post.contentKey)
        self.image = try row.get(Post.imageKey)
        self.track_id = try row.get(Post.track_idKey)
        
    }
    
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Post.contentKey, content)
        try row.set(Post.imageKey, image)
        try row.set(Post.track_idKey, track_id)
        return row
    }
}
// For database prepare and revert
extension Post: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create(self) { (post) in
            post.id()
            post.string(Post.contentKey, length: 1500)
            post.string(Post.imageKey)
            post.foreignId(for: Track.self)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

// Convenience of generate model from JSON
extension Post: JSONConvertible {
    
    convenience init(json: JSON) throws {
        self.init(content: try json.get(Post.contentKey),
                  image: try json.get(Post.imageKey),
                  track_id: try json.get(Post.track_idKey)
        )}
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Post.idKey, id)
        try json.set(Post.contentKey, content)
        try json.set(Post.imageKey, image)
        try json.set(Post.track_idKey, track_id)
        return json
    }
}


extension Post: Timestampable {}


// Convenience of returning response
extension Post: ResponseRepresentable {}


extension Post {
    
    var comments: Children<Post, PostComment> {
        return children()
    }
    
    var likes: Children<Post, PostLike> {
        return children()
    }
    
}
