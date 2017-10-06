//
//  Event.swift
//  traxapi
//
//  Created by Mugurel Moscaliuc on 06/10/2017.
//
//

import PostgreSQLProvider

final class Event: Model {
    
    let storage = Storage()
    var content: String
    var event_date: Date
    var track_id: Int
    
    
    // Use these keys instead of magic strings
    
    
    static let idKey = "id"
    static let contentKey = "content"
    static let event_dateKey = "event_date"
    static let track_idKey = "track_id"
    
    
    init(content: String,
         event_date: Date,
         track_id: Int
        ) {
        self.content = content
        self.event_date = event_date
        self.track_id = track_id
    }
    
    
    init(row: Row) throws {
        self.content = try row.get(Event.contentKey)
        self.event_date = try row.get(Event.event_dateKey)
        self.track_id = try row.get(Event.track_idKey)
        
    }
    
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Event.contentKey, content)
        try row.set(Event.event_dateKey, event_date)
        try row.set(Event.track_idKey, track_id)
        return row
    }
}
// For database prepare and revert
extension Event: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create(self) { (builder) in
            builder.id()
            builder.string(Event.contentKey)
            builder.string(Event.event_dateKey)
            builder.foreignId(for: Track.self)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

// Convenience of generate model from JSON
extension Event: JSONConvertible {
    
    convenience init(json: JSON) throws {
        self.init(content: try json.get(Event.contentKey),
                  event_date: try json.get(Event.event_dateKey),
                  track_id: try json.get(Event.track_idKey)
        )}
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Event.idKey, id)
        try json.set(Event.contentKey, content)
        try json.set(Event.event_dateKey, event_date)
        try json.set(Event.track_idKey, track_id)
        return json
    }
}


extension Event: Timestampable {}


// Convenience of returning response
extension Event: ResponseRepresentable {}
