//
//  ReviewReply.swift
//  traxapi
//
//  Created by Mugurel Moscaliuc on 06/10/2017.
//
//

import PostgreSQLProvider

final class ReviewReply: Model {
    
    let storage = Storage()
    var content: String
    var review_comment_id: Int
    
    
    // Use these keys instead of magic strings
    static let idKey = "id"
    static let contentKey = "content"
    static let review_comment_idKey = "review_comment_id"
    static let user_idKey = "user_id"
    
    
    init(content: String,
         review_comment_id: Int
        ) {
        self.content = content
        self.review_comment_id = review_comment_id
        
    }
    
    
    init(row: Row) throws {
        self.content = try row.get(ReviewReply.contentKey)
        self.review_comment_id = try row.get(ReviewReply.review_comment_idKey)
        
    }
    
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(ReviewReply.contentKey, content)
        try row.set(ReviewReply.review_comment_idKey, review_comment_id)
        return row
    }
}
// For database prepare and revert
extension ReviewReply: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create(self) { (builder) in
            builder.id()
            builder.string(ReviewReply.contentKey)
            //builder.int(ReviewReply.user_idKey)
            builder.parent(User.self, optional: false)
            builder.foreignId(for: ReviewComment.self)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

// Convenience of generate model from JSON
extension ReviewReply: JSONConvertible {
    
    convenience init(json: JSON) throws {
        self.init(content: try json.get(ReviewReply.contentKey),
                  review_comment_id: try json.get(ReviewReply.review_comment_idKey)
        )}
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(ReviewReply.idKey, id)
        try json.set(ReviewReply.contentKey, content)
        try json.set(ReviewReply.review_comment_idKey, review_comment_id)
        return json
    }
}


extension ReviewReply: Timestampable {}


// Convenience of returning response
extension ReviewReply: ResponseRepresentable {}
