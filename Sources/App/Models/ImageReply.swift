//
//  ImageReply.swift
//  traxapi
//
//  Created by Mugurel Moscaliuc on 06/10/2017.
//
//

import PostgreSQLProvider

final class ImageReply: Model {
    
    let storage = Storage()
    var content: String
    var image_comment_id: Int
    
    
    // Use these keys instead of magic strings
    static let idKey = "id"
    static let contentKey = "content"
    static let image_comment_idKey = "image_comment_id"
    static let user_idKey = "user_id"
    
    
    init(content: String,
         image_comment_id: Int
        ) {
        self.content = content
        self.image_comment_id = image_comment_id
        
    }
    
    
    init(row: Row) throws {
        self.content = try row.get(ImageReply.contentKey)
        self.image_comment_id = try row.get(ImageReply.image_comment_idKey)
        
    }
    
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(ImageReply.contentKey, content)
        try row.set(ImageReply.image_comment_idKey, image_comment_id)
        return row
    }
}
// For database prepare and revert
extension ImageReply: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create(self) { (builder) in
            builder.id()
            builder.string(ImageReply.contentKey)
            //builder.int(ImageReply.user_idKey)
            builder.parent(User.self, optional: false)
            builder.foreignId(for: ImageComment.self)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

// Convenience of generate model from JSON
extension ImageReply: JSONConvertible {
    
    convenience init(json: JSON) throws {
        self.init(content: try json.get(ImageReply.contentKey),
                  image_comment_id: try json.get(ImageReply.image_comment_idKey)
        )}
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(ImageReply.idKey, id)
        try json.set(ImageReply.contentKey, content)
        try json.set(ImageReply.image_comment_idKey, image_comment_id)
        return json
    }
}


extension ImageReply: Timestampable {}


// Convenience of returning response
extension ImageReply: ResponseRepresentable {}
