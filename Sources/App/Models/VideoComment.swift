//
//  VideoComment.swift
//  traxapi
//
//  Created by Mugurel Moscaliuc on 06/10/2017.
//
//

import PostgreSQLProvider

final class VideoComment: Model {
    
    let storage = Storage()
    var content: String
    var video_id: Int
    
    
    // Use these keys instead of magic strings
    static let idKey = "id"
    static let contentKey = "content"
    static let video_idKey = "video_id"
    static let user_idKey = "user_id"
    
    
    init(content: String,
         video_id: Int
        ) {
        self.content = content
        self.video_id = video_id
        
    }
    
    
    init(row: Row) throws {
        self.content = try row.get(VideoComment.contentKey)
        self.video_id = try row.get(VideoComment.video_idKey)
        
    }
    
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(VideoComment.contentKey, content)
        try row.set(VideoComment.video_idKey, video_id)
        return row
    }
}
// For database prepare and revert
extension VideoComment: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create(self) { (builder) in
            builder.id()
            builder.string(VideoComment.contentKey)
            //builder.int(VideoComment.user_idKey)
            builder.parent(User.self, optional: false)
            builder.foreignId(for: Video.self)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

// Convenience of generate model from JSON
extension VideoComment: JSONConvertible {
    
    convenience init(json: JSON) throws {
        self.init(content: try json.get(VideoComment.contentKey),
                  video_id: try json.get(VideoComment.video_idKey)
        )}
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(VideoComment.idKey, id)
        try json.set(VideoComment.contentKey, content)
        try json.set(VideoComment.video_idKey, video_id)
        return json
    }
}


extension VideoComment: Timestampable {}


// Convenience of returning response
extension VideoComment: ResponseRepresentable {}


extension VideoComment {
    
    var replies: Children<VideoComment, VideoReply> {
        return children()
    }
    
    
}
