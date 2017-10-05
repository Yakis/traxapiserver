//
//  Image.swift
//  traxapi
//
//  Created by Mugurel Moscaliuc on 23/09/2017.
//
//

import PostgreSQLProvider

final class Image: Model {
    
    let storage = Storage()
    var imageUrl: String
    var track_id: Int
    
    
    // Use these keys instead of magic strings
    static let idKey = "id"
    static let imageUrlKey = "image_url"
    static let track_idKey = "track_id"
    static let imagesKey = "images"
    
    
    init(imageUrl: String,
         track_id: Int
        ) {
        self.imageUrl = imageUrl
        self.track_id = track_id
        
    }
    
    
    init(row: Row) throws {
        self.imageUrl = try row.get(Image.imageUrlKey)
        self.track_id = try row.get(Image.track_idKey)
        
    }
    
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Image.imageUrlKey, imageUrl)
        try row.set(Image.track_idKey, track_id)
        return row
    }
}
// For database prepare and revert
extension Image: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create(self) { (image) in
            image.id()
            image.string(Image.imageUrlKey)
            image.foreignId(for: Track.self)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

// Convenience of generate model from JSON
extension Image: JSONConvertible {
    
    convenience init(json: JSON) throws {
        self.init(imageUrl: try json.get(Image.imageUrlKey),
                  track_id: try json.get(Image.track_idKey)
        )}
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Image.idKey, id)
        try json.set(Image.imageUrlKey, imageUrl)
        try json.set(Image.track_idKey, track_id)
        return json
    }
}

// Convenience of returning response
extension Image: ResponseRepresentable {}
