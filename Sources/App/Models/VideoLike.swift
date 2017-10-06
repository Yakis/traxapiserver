//
//  VideoLike.swift
//  traxapi
//
//  Created by Mugurel Moscaliuc on 06/10/2017.
//
//

import PostgreSQLProvider

final class VideoLike: Model {
    
    let storage = Storage()
    var user_id: Int
    var video_id: Int
    
    
    // Use these keys instead of magic strings
    static let idKey = "id"
    static let user_idKey = "user_id"
    static let video_idKey = "video_id"
    
    
    init(user_id: Int,
         video_id: Int
        ) {
        self.user_id = user_id
        self.video_id = video_id
    }
    
    
    init(row: Row) throws {
        self.user_id = try row.get(VideoLike.user_idKey)
        self.video_id = try row.get(VideoLike.video_idKey)
        
    }
    
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(VideoLike.user_idKey, user_id)
        try row.set(VideoLike.video_idKey, video_id)
        return row
    }
}
// For database prepare and revert
extension VideoLike: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create(self) { (builder) in
            builder.id()
            builder.int(VideoLike.user_idKey)
            builder.foreignId(for: Video.self)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

// Convenience of generate model from JSON
extension VideoLike: JSONConvertible {
    
    convenience init(json: JSON) throws {
        self.init(user_id: try json.get(VideoLike.user_idKey),
                  video_id: try json.get(VideoLike.video_idKey)
        )}
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(VideoLike.idKey, id)
        try json.set(VideoLike.video_idKey, video_id)
        return json
    }
}




// Convenience of returning response
extension VideoLike: ResponseRepresentable {}
