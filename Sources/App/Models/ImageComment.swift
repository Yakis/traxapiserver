//
//  ImageComment.swift
//  traxapi
//
//  Created by Mugurel Moscaliuc on 06/10/2017.
//
//

import PostgreSQLProvider

final class ImageComment: Model {
    
    let storage = Storage()
    var content: String
    var image_id: Int
    
    
    // Use these keys instead of magic strings
    static let idKey = "id"
    static let contentKey = "content"
    static let image_idKey = "image_id"
    static let user_idKey = "user_id"
    
    
    init(content: String,
         image_id: Int
        ) {
        self.content = content
        self.image_id = image_id
        
    }
    
    
    init(row: Row) throws {
        self.content = try row.get(ImageComment.contentKey)
        self.image_id = try row.get(ImageComment.image_idKey)
        
    }
    
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(ImageComment.contentKey, content)
        try row.set(ImageComment.image_idKey, image_id)
        return row
    }
}
// For database prepare and revert
extension ImageComment: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create(self) { (builder) in
            builder.id()
            builder.string(ImageComment.contentKey)
            //builder.int(ImageComment.user_idKey)
            builder.parent(User.self, optional: false)
            builder.foreignId(for: Image.self)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

// Convenience of generate model from JSON
extension ImageComment: JSONConvertible {
    
    convenience init(json: JSON) throws {
        self.init(content: try json.get(ImageComment.contentKey),
                  image_id: try json.get(ImageComment.image_idKey)
        )}
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(ImageComment.idKey, id)
        try json.set(ImageComment.contentKey, content)
        try json.set(ImageComment.image_idKey, image_id)
        return json
    }
}


extension ImageComment: Timestampable {}


// Convenience of returning response
extension ImageComment: ResponseRepresentable {}


extension ImageComment {
    
    var replies: Children<ImageComment, ImageReply> {
        return children()
    }
    
    
}
