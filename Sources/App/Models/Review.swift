//
//  Review.swift
//  traxapi
//
//  Created by Mugurel Moscaliuc on 05/10/2017.
//
//

import PostgreSQLProvider

final class Review: Model {
    
    let storage = Storage()
    var stars: Int
    var content: String
    var track_id: Int
    
    
    // Use these keys instead of magic strings
    static let idKey = "id"
    static let starsKey = "stars"
    static let contentKey = "content"
    static let userIdKey = "user_id"
    static let track_idKey = "track_id"
    
    
    init(stars: Int, content: String,
         track_id: Int
        ) {
        self.stars = stars
        self.content = content
        self.track_id = track_id
        
    }
    
    
    init(row: Row) throws {
        self.stars = try row.get(Review.starsKey)
        self.content = try row.get(Review.contentKey)
        self.track_id = try row.get(Review.track_idKey)
        
    }
    
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Review.contentKey, content)
        try row.set(Review.starsKey, stars)
        try row.set(Review.track_idKey, track_id)
        return row
    }
}
// For database prepare and revert
extension Review: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create(self) { (builder) in
            builder.id()
            builder.int(Review.starsKey)
            builder.string(Review.contentKey)
            builder.int(Review.userIdKey)
            builder.foreignId(for: Track.self)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

// Convenience of generate model from JSON
extension Review: JSONConvertible {
    
    convenience init(json: JSON) throws {
        self.init(stars: try json.get(Review.starsKey),
                  content: try json.get(Review.contentKey),
                  track_id: try json.get(Review.track_idKey)
        )}
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Review.idKey, id)
        try json.set(Review.contentKey, content)
        try json.set(Review.starsKey, stars)
        try json.set(Review.track_idKey, track_id)
        return json
    }
}


extension Review: Timestampable {}


// Convenience of returning response
extension Review: ResponseRepresentable {}


extension Review {
    
    var comments: Children<Review, ReviewComment> {
        return children()
    }
    
}
