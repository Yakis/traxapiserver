//
//  AdvertImage.swift
//  traxapi
//
//  Created by Mugurel Moscaliuc on 06/10/2017.
//
//

import PostgreSQLProvider

final class AdvertImage: Model {
    
    let storage = Storage()
    var imageUrl: String
    var advert_id: Int
    
    
    // Use these keys instead of magic strings
    static let idKey = "id"
    static let imageUrlKey = "image_url"
    static let advert_idKey = "advert_id"
    
    
    init(imageUrl: String,
         advert_id: Int
        ) {
        self.imageUrl = imageUrl
        self.advert_id = advert_id
        
    }
    
    
    init(row: Row) throws {
        self.imageUrl = try row.get(AdvertImage.imageUrlKey)
        self.advert_id = try row.get(AdvertImage.advert_idKey)
        
    }
    
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(AdvertImage.imageUrlKey, imageUrl)
        try row.set(AdvertImage.advert_idKey, advert_id)
        return row
    }
}
// For database prepare and revert
extension AdvertImage: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create(self) { (builder) in
            builder.id()
            builder.string(AdvertImage.imageUrlKey)
            builder.foreignId(for: Advert.self)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

// Convenience of generate model from JSON
extension AdvertImage: JSONConvertible {
    
    convenience init(json: JSON) throws {
        self.init(imageUrl: try json.get(AdvertImage.imageUrlKey),
                  advert_id: try json.get(AdvertImage.advert_idKey)
        )}
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(AdvertImage.idKey, id)
        try json.set(AdvertImage.imageUrlKey, imageUrl)
        try json.set(AdvertImage.advert_idKey, advert_id)
        return json
    }
}

// Convenience of returning response
extension AdvertImage: ResponseRepresentable {}
