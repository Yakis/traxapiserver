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
    var soilType: String
    var openingTimes: String
    var prices: String
    var childFriendly: Bool
    var rating: Double
    var ownerId: Int
    
    
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
    static let ownerIdKey = "owner_id"
    
    init(name: String,
         adress: String,
         postcode: String,
         latitude: Double,
         longitude: Double,
         soilType: String,
         openingTimes: String,
         prices: String,
         childFriendly: Bool,
         rating: Double,
         ownerId: Int
        ) {
        self.name = name
        self.adress = adress
        self.postcode = postcode
        self.latitude = latitude
        self.longitude = longitude
        self.soilType = soilType
        self.openingTimes = openingTimes
        self.prices = prices
        self.childFriendly = childFriendly
        self.rating = rating
        self.ownerId = ownerId
    }
    
    
    init(row: Row) throws {
        self.name = try row.get(Track.nameKey)
        self.adress = try row.get(Track.adressKey)
        self.postcode = try row.get(Track.postcodeKey)
        self.latitude = try row.get(Track.latitudeKey)
        self.longitude = try row.get(Track.longitudeKey)
        self.soilType = try row.get(Track.soilTypeKey)
        self.openingTimes = try row.get(Track.openingTimesKey)
        self.prices = try row.get(Track.pricesKey)
        self.childFriendly = try row.get(Track.childFriendlyKey)
        self.rating = try row.get(Track.ratingKey)
        self.ownerId = try row.get(Track.ownerIdKey)
    }
    
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Track.nameKey, name)
        try row.set(Track.adressKey, adress)
        try row.set(Track.postcodeKey, postcode)
        try row.set(Track.latitudeKey, latitude)
        try row.set(Track.longitudeKey, longitude)
        try row.set(Track.soilTypeKey, soilType)
        try row.set(Track.openingTimesKey, openingTimes)
        try row.set(Track.pricesKey, prices)
        try row.set(Track.childFriendlyKey, childFriendly)
        try row.set(Track.ratingKey, rating)
        try row.set(Track.ownerIdKey, ownerId)
        return row
    }
}
// For database prepare and revert
extension Track: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create(self) { (track) in
            track.id()
            track.string(Track.nameKey)
            track.string(Track.adressKey)
            track.string(Track.postcodeKey)
            track.double(Track.latitudeKey)
            track.double(Track.longitudeKey)
            track.string(Track.soilTypeKey)
            track.string(Track.openingTimesKey)
            track.string(Track.pricesKey)
            track.bool(Track.childFriendlyKey)
            track.double(Track.ratingKey)
            track.int(Track.ownerIdKey)
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
                  soilType: try json.get(Track.soilTypeKey),
                  openingTimes: try json.get(Track.openingTimesKey),
                  prices: try json.get(Track.pricesKey),
                  childFriendly: try json.get(Track.childFriendlyKey),
                  rating: try json.get(Track.ratingKey),
                  ownerId: try json.get(Track.ownerIdKey))
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Track.idKey, id)
        try json.set(Track.nameKey, name)
        try json.set(Track.adressKey, adress)
        try json.set(Track.postcodeKey, postcode)
        try json.set(Track.latitudeKey, latitude)
        try json.set(Track.longitudeKey, longitude)
        try json.set(Track.soilTypeKey, soilType)
        try json.set(Track.openingTimesKey, openingTimes)
        try json.set(Track.pricesKey, prices)
        try json.set(Track.childFriendlyKey, childFriendly)
        try json.set(Track.ratingKey, rating)
        try json.set(Track.ownerIdKey, ownerId)
        return json
    }
}

// Convenience of returning response
extension Track: ResponseRepresentable {}
