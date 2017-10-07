//
//  ReviewComment.swift
//  traxapi
//
//  Created by Mugurel Moscaliuc on 06/10/2017.
//
//

import PostgreSQLProvider

final class ReviewComment: Model {
    
    let storage = Storage()
    var content: String
    var review_id: Int
    
    
    // Use these keys instead of magic strings
    static let idKey = "id"
    static let contentKey = "content"
    static let review_idKey = "review_id"
    static let owner_idKey = "owner_id"
    
    
    init(content: String,
         review_id: Int
        ) {
        self.content = content
        self.review_id = review_id
        
    }
    
    
    init(row: Row) throws {
        self.content = try row.get(ReviewComment.contentKey)
        self.review_id = try row.get(ReviewComment.review_idKey)
        
    }
    
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(ReviewComment.contentKey, content)
        try row.set(ReviewComment.review_idKey, review_id)
        return row
    }
}
// For database prepare and revert
extension ReviewComment: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create(self) { (builder) in
            builder.id()
            builder.string(ReviewComment.contentKey)
            //builder.int(ReviewComment.owner_idKey)
            builder.parent(Owner.self, optional: false)
            builder.foreignId(for: Review.self)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

// Convenience of generate model from JSON
extension ReviewComment: JSONConvertible {
    
    convenience init(json: JSON) throws {
        self.init(content: try json.get(ReviewComment.contentKey),
                  review_id: try json.get(ReviewComment.review_idKey)
        )}
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(ReviewComment.idKey, id)
        try json.set(ReviewComment.contentKey, content)
        try json.set(ReviewComment.review_idKey, review_id)
        return json
    }
}


extension ReviewComment: Timestampable {}


// Convenience of returning response
extension ReviewComment: ResponseRepresentable {}


extension ReviewComment {
    
    var replies: Children<ReviewComment, ReviewReply> {
        return children()
    }
    
    
}
