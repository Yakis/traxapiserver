//
//  Track.swift
//  traxapi
//
//  Created by Mugurel Moscaliuc on 23/09/2017.
//
//

import PostgreSQLProvider

final class Track: Model {
    
    let storage = Storage()
    var name: String
    var adress: String
    var postcode: String
    var latitude: Double
    var longitude: Double
    var soil_type: String
    var opening_times: String
    var prices: String
    var child_friendly: Bool
    var rating: Double
    var user_id: Int
    var image: String
    var featured: Int
    
    
    // Use these keys instead of magic strings
    static let idKey = "id"
    static let nameKey = "name"
    static let adressKey = "adress"
    static let postcodeKey = "postcode"
    static let latitudeKey = "latitude"
    static let longitudeKey = "longitude"
    static let soilTypeKey = "soil_type"
    static let openingTimesKey = "opening_times"
    static let pricesKey = "prices"
    static let childFriendlyKey = "child_friendly"
    static let ratingKey = "rating"
    static let imageKey = "image"
    static let userIdKey = "user_id"
    static let featuredKey = "featured"
    static let user_idKey = "user_id"
    
    init(name: String,
         adress: String,
         postcode: String,
         latitude: Double,
         longitude: Double,
         soil_type: String,
         opening_times: String,
         prices: String,
         child_friendly: Bool,
         rating: Double,
         user_id: Int,
         image: String,
         featured: Int
        ) {
        self.name = name
        self.adress = adress
        self.postcode = postcode
        self.latitude = latitude
        self.longitude = longitude
        self.soil_type = soil_type
        self.opening_times = opening_times
        self.prices = prices
        self.child_friendly = child_friendly
        self.rating = rating
        self.user_id = user_id
        self.image = image
        self.featured = featured
    }
    
    
    init(row: Row) throws {
        self.name = try row.get(Track.nameKey)
        self.adress = try row.get(Track.adressKey)
        self.postcode = try row.get(Track.postcodeKey)
        self.latitude = try row.get(Track.latitudeKey)
        self.longitude = try row.get(Track.longitudeKey)
        self.soil_type = try row.get(Track.soilTypeKey)
        self.opening_times = try row.get(Track.openingTimesKey)
        self.prices = try row.get(Track.pricesKey)
        self.child_friendly = try row.get(Track.childFriendlyKey)
        self.rating = try row.get(Track.ratingKey)
        self.user_id = try row.get(Track.user_idKey)
        self.image = try row.get(Track.imageKey)
        self.featured = try row.get(Track.featuredKey)
    }
    
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Track.nameKey, name)
        try row.set(Track.adressKey, adress)
        try row.set(Track.postcodeKey, postcode)
        try row.set(Track.latitudeKey, latitude)
        try row.set(Track.longitudeKey, longitude)
        try row.set(Track.soilTypeKey, soil_type)
        try row.set(Track.openingTimesKey, opening_times)
        try row.set(Track.pricesKey, prices)
        try row.set(Track.childFriendlyKey, child_friendly)
        try row.set(Track.ratingKey, rating)
        try row.set(Track.user_idKey, user_id)
        try row.set(Track.imageKey, image)
        try row.set(Track.featuredKey, featured)
        return row
    }
}
// For database prepare and revert
extension Track: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create(self) { (builder) in
            builder.id()
            builder.string(Track.nameKey)
            builder.string(Track.adressKey)
            builder.string(Track.postcodeKey)
            builder.double(Track.latitudeKey)
            builder.double(Track.longitudeKey)
            builder.string(Track.soilTypeKey)
            builder.string(Track.openingTimesKey)
            builder.string(Track.pricesKey)
            builder.bool(Track.childFriendlyKey)
            builder.double(Track.ratingKey)
            builder.string(Track.imageKey)
            builder.int(Track.featuredKey)
            builder.foreignId(for: User.self)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

// Convenience of generate model from JSON
extension Track: JSONConvertible {
    
    convenience init(json: JSON) throws {
        self.init(name: try json.get(Track.nameKey),
                  adress: try json.get(Track.adressKey),
                  postcode: try json.get(Track.postcodeKey),
                  latitude: try json.get(Track.latitudeKey),
                  longitude: try json.get(Track.longitudeKey),
                  soil_type: try json.get(Track.soilTypeKey),
                  opening_times: try json.get(Track.openingTimesKey),
                  prices: try json.get(Track.pricesKey),
                  child_friendly: try json.get(Track.childFriendlyKey),
                  rating: try json.get(Track.ratingKey),
                  user_id: try json.get(Track.user_idKey),
                  image: try json.get(Track.imageKey),
                  featured: try json.get(Track.featuredKey))
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Track.idKey, id)
        try json.set(Track.nameKey, name)
        try json.set(Track.adressKey, adress)
        try json.set(Track.postcodeKey, postcode)
        try json.set(Track.latitudeKey, latitude)
        try json.set(Track.longitudeKey, longitude)
        try json.set(Track.soilTypeKey, soil_type)
        try json.set(Track.openingTimesKey, opening_times)
        try json.set(Track.pricesKey, prices)
        try json.set(Track.childFriendlyKey, child_friendly)
        try json.set(Track.ratingKey, rating)
        try json.set(Track.user_idKey, user_id)
        try json.set(Track.imageKey, image)
        try json.set(Track.featuredKey, featured)
        return json
    }
}


extension Track: Timestampable {}


// Convenience of returning response
extension Track: ResponseRepresentable {}

extension Track {
    var images: Children<Track, Image> {
        return children()
    }
    
    
    var videos: Children<Track, Video> {
        return children()
    }
    
    
    var posts: Children<Track, Post> {
        return children()
    }
    
    
    var reviews: Children<Track, Review> {
        return children()
    }
    
    var events: Children<Track, Event> {
        return children()
    }
    
}
