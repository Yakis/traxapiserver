//
//  ImageLike.swift
//  traxapi
//
//  Created by Mugurel Moscaliuc on 06/10/2017.
//
//

import PostgreSQLProvider

final class ImageLike: Model {
    
    let storage = Storage()
    var user_id: Int
    var image_id: Int
    
    
    // Use these keys instead of magic strings
    static let idKey = "id"
    static let user_idKey = "user_id"
    static let image_idKey = "image_id"
    
    
    init(user_id: Int,
         image_id: Int
        ) {
        self.user_id = user_id
        self.image_id = image_id
    }
    
    
    init(row: Row) throws {
        self.user_id = try row.get(ImageLike.user_idKey)
        self.image_id = try row.get(ImageLike.image_idKey)
        
    }
    
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(ImageLike.user_idKey, user_id)
        try row.set(ImageLike.image_idKey, image_id)
        return row
    }
}
// For database prepare and revert
extension ImageLike: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create(self) { (builder) in
            builder.id()
            //builder.int(ImageLike.user_idKey)
            builder.parent(User.self, optional: false)
            builder.foreignId(for: Image.self)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

// Convenience of generate model from JSON
extension ImageLike: JSONConvertible {
    
    convenience init(json: JSON) throws {
        self.init(user_id: try json.get(ImageLike.user_idKey),
                  image_id: try json.get(ImageLike.image_idKey)
        )}
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(ImageLike.idKey, id)
        try json.set(ImageLike.image_idKey, image_id)
        return json
    }
}




// Convenience of returning response
extension ImageLike: ResponseRepresentable {}
