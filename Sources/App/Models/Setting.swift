//
//  Setting.swift
//  traxapi
//
//  Created by Mugurel Moscaliuc on 23/09/2017.
//
//

import PostgreSQLProvider

final class Setting: Model {
    
    let storage = Storage()
    var trackUpdate: Bool
    var tagNotify: Bool
    var locationEnabled: Bool
    var user_id: Int
    
    
    // Use these keys instead of magic strings
    static let idKey = "id"
    static let trackUpdateKey = "trackUpdate"
    static let tagNotifyKey = "tagNotify"
    static let locationEnabledKey = "locationEnabled"
    static let user_idKey = "user_id"
    
    
    init(trackUpdate: Bool,
         tagNotify: Bool,
         locationEnabled: Bool,
         user_id: Int
        ) {
        self.trackUpdate = trackUpdate
        self.tagNotify = tagNotify
        self.locationEnabled = locationEnabled
        self.user_id = user_id
        
    }
    
    
    init(row: Row) throws {
        self.trackUpdate = try row.get(Setting.trackUpdateKey)
        self.tagNotify = try row.get(Setting.tagNotifyKey)
        self.locationEnabled = try row.get(Setting.locationEnabledKey)
        self.user_id = try row.get(Setting.user_idKey)
        
    }
    
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Setting.trackUpdateKey, trackUpdate)
        try row.set(Setting.tagNotifyKey, tagNotify)
        try row.set(Setting.locationEnabledKey, locationEnabled)
        try row.set(Setting.user_idKey, user_id)
        return row
    }
}
// For database prepare and revert
extension Setting: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create(self) { (setting) in
            setting.id()
            setting.string(Setting.trackUpdateKey)
            setting.string(Setting.tagNotifyKey)
            setting.string(Setting.locationEnabledKey)
            setting.string(Setting.user_idKey)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

// Convenience of generate model from JSON
extension Setting: JSONConvertible {
    
    convenience init(json: JSON) throws {
        self.init(trackUpdate: try json.get(Setting.trackUpdateKey),
                  tagNotify: try json.get(Setting.tagNotifyKey),
                  locationEnabled: try json.get(Setting.locationEnabledKey),
                  user_id: try json.get(Setting.user_idKey)
        )}
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Setting.idKey, id)
        try json.set(Setting.trackUpdateKey, trackUpdate)
        try json.set(Setting.tagNotifyKey, tagNotify)
        try json.set(Setting.locationEnabledKey, locationEnabled)
        try json.set(Setting.user_idKey, user_id)
        return json
    }
}

// Convenience of returning response
extension Setting: ResponseRepresentable {}
