//
//  Advert.swift
//  traxapi
//
//  Created by Mugurel Moscaliuc on 06/10/2017.
//
//

import PostgreSQLProvider

final class Advert: Model {
    
    let storage = Storage()
    var title: String
    var description: String
    var price: Double
    var user_id: Int
    
    
    // Use these keys instead of magic strings
    static let idKey = "id"
    static let titleKey = "title"
    static let descriptionKey = "description"
    static let priceKey = "price"
    static let user_idKey = "user_id"
    
    
    init(title: String, description: String,
         price: Double,
         user_id: Int
        ) {
        self.title = title
        self.description = description
        self.price = price
        self.user_id = user_id
        
    }
    
    
    init(row: Row) throws {
        self.title = try row.get(Advert.titleKey)
        self.description = try row.get(Advert.descriptionKey)
        self.price = try row.get(Advert.priceKey)
        self.user_id = try row.get(Advert.user_idKey)
        
    }
    
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Advert.titleKey, title)
        try row.set(Advert.descriptionKey, description)
        try row.set(Advert.priceKey, price)
        try row.set(Advert.user_idKey, user_id)
        return row
    }
}
// For database prepare and revert
extension Advert: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create(self) { (builder) in
            builder.id()
            builder.string(Advert.titleKey)
            builder.string(Advert.descriptionKey)
            builder.double(Advert.priceKey)
            builder.foreignId(for: User.self)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

// Convenience of generate model from JSON
extension Advert: JSONConvertible {
    
    convenience init(json: JSON) throws {
        self.init(title: try json.get(Advert.titleKey), description: try json.get(Advert.descriptionKey),
                  price: try json.get(Advert.priceKey),
                  user_id: try json.get(Advert.user_idKey)
        )}
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Advert.idKey, id)
        try json.set(Advert.titleKey, title)
        try json.set(Advert.descriptionKey, description)
        try json.set(Advert.priceKey, price)
        try json.set(Advert.user_idKey, user_id)
        return json
    }
}


extension Advert: Timestampable {}


// Convenience of returning response
extension Advert: ResponseRepresentable {}


extension Advert {
    
    var images: Children<Advert, AdvertImage> {
        return children()
    }
    
    var messages: Children<Advert, AdvertMessage> {
        return children()
    }
    
}
