//
//  VideoReply.swift
//  traxapi
//
//  Created by Mugurel Moscaliuc on 06/10/2017.
//
//

import PostgreSQLProvider

final class VideoReply: Model {
    
    let storage = Storage()
    var content: String
    var video_comment_id: Int
    
    
    // Use these keys instead of magic strings
    static let idKey = "id"
    static let contentKey = "content"
    static let video_comment_idKey = "video_comment_id"
    static let user_idKey = "user_id"
    
    
    init(content: String,
         video_comment_id: Int
        ) {
        self.content = content
        self.video_comment_id = video_comment_id
        
    }
    
    
    init(row: Row) throws {
        self.content = try row.get(VideoReply.contentKey)
        self.video_comment_id = try row.get(VideoReply.video_comment_idKey)
        
    }
    
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(VideoReply.contentKey, content)
        try row.set(VideoReply.video_comment_idKey, video_comment_id)
        return row
    }
}
// For database prepare and revert
extension VideoReply: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create(self) { (builder) in
            builder.id()
            builder.string(VideoReply.contentKey)
            builder.int(VideoReply.user_idKey)
            builder.foreignId(for: VideoComment.self)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

// Convenience of generate model from JSON
extension VideoReply: JSONConvertible {
    
    convenience init(json: JSON) throws {
        self.init(content: try json.get(VideoReply.contentKey),
                  video_comment_id: try json.get(VideoReply.video_comment_idKey)
        )}
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(VideoReply.idKey, id)
        try json.set(VideoReply.contentKey, content)
        try json.set(VideoReply.video_comment_idKey, video_comment_id)
        return json
    }
}


extension VideoReply: Timestampable {}


// Convenience of returning response
extension VideoReply: ResponseRepresentable {}
