//
//  VideoRepliesController.swift
//  traxapi
//
//  Created by Mugurel Moscaliuc on 10/10/2017.
//
//

import PostgreSQLProvider

final class VideoRepliesController {
    
    
    fileprivate func getByComment(request: Request) throws -> ResponseRepresentable {
        guard let comment = request.query?["id"]?.int else {
            fatalError("Comment not found!)")
        }
        let replies = try VideoReply.all().filter { $0.video_comment_id == comment }
        return try replies.makeJSON()
    }
    
    
    fileprivate func create(request: Request) throws -> ResponseRepresentable {
        guard let json = request.json else { throw Abort.badRequest }
        let reply = try VideoReply(json: json)
        try reply.save()
        return reply
    }
    
    
    fileprivate func update(request: Request) throws -> ResponseRepresentable {
        let videoReply = try request.parameters.next(VideoReply.self)
        guard let json = request.json else { throw Abort.badRequest }
        let newVideoReply = try VideoReply(json: json)
        videoReply.content = newVideoReply.content
        videoReply.video_comment_id = newVideoReply.video_comment_id
        try videoReply.save()
        return videoReply
    }
    
    
    fileprivate func delete(request: Request) throws -> ResponseRepresentable {
        guard let json = request.json else { throw Abort.badRequest }
        let reply = try VideoReply(json: json)
        try reply.delete()
        return reply
    }
    
    
    
    func addRoutes(to routeBuilder: RouteBuilder) {
        
        // /api/v1/videoreplies/create
        routeBuilder.post("create", handler: create)
        
        // /api/v1/videoreplies/:id
        routeBuilder.patch(ImageReply.parameter, handler: update)
        routeBuilder.delete(ImageReply.parameter, handler: delete)
        
        // /api/v1/videoreplies/comment?id=1
        routeBuilder.get("comment", handler: getByComment)
    }
    
    
}
