//
//  Video.swift
//  traxapi
//
//  Created by Mugurel Moscaliuc on 05/10/2017.
//
//

import PostgreSQLProvider

final class Video: Model {
    
    let storage = Storage()
    var videoUrl: String
    var track_id: Int
    
    
    // Use these keys instead of magic strings
    static let idKey = "id"
    static let videoUrlKey = "video_url"
    static let track_idKey = "track_id"
    static let videosKey = "videos"
    
    
    init(videoUrl: String,
         track_id: Int
        ) {
        self.videoUrl = videoUrl
        self.track_id = track_id
        
    }
    
    
    init(row: Row) throws {
        self.videoUrl = try row.get(Video.videoUrlKey)
        self.track_id = try row.get(Video.track_idKey)
        
    }
    
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Video.videoUrlKey, videoUrl)
        try row.set(Video.track_idKey, track_id)
        return row
    }
}
// For database prepare and revert
extension Video: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create(self) { (builder) in
            builder.id()
            builder.string(Video.videoUrlKey)
            builder.foreignId(for: Track.self)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

// Convenience of generate model from JSON
extension Video: JSONConvertible {
    
    convenience init(json: JSON) throws {
        self.init(videoUrl: try json.get(Video.videoUrlKey),
                  track_id: try json.get(Video.track_idKey)
        )}
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Video.idKey, id)
        try json.set(Video.videoUrlKey, videoUrl)
        try json.set(Video.track_idKey, track_id)
        return json
    }
}

// Convenience of returning response
extension Video: ResponseRepresentable {}


extension Video {
    
    var comments: Children<Video, VideoComment> {
        return children()
    }
    
    
    var likes: Children<Video, VideoLike> {
        return children()
    }
    
    
}
