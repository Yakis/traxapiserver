//
//  PostsRepliesController.swift
//  traxapi
//
//  Created by Mugurel Moscaliuc on 10/10/2017.
//
//

import PostgreSQLProvider

final class PostRepliesController {
    
    
    fileprivate func getByComment(request: Request) throws -> ResponseRepresentable {
        guard let comment = request.query?["id"]?.int else {
            fatalError("Comment not found!)")
        }
        let replies = try PostReply.all().filter { $0.post_comment_id == comment }
        return try replies.makeJSON()
    }
    
    
    fileprivate func create(request: Request) throws -> ResponseRepresentable {
        guard let json = request.json else { throw Abort.badRequest }
        let reply = try PostReply(json: json)
        try reply.save()
        return reply
    }
    
    
    fileprivate func update(request: Request) throws -> ResponseRepresentable {
        guard let json = request.json else { throw Abort.badRequest }
        let reply = try PostReply(json: json)
        try reply.save()
        return reply
    }
    
    
    fileprivate func delete(request: Request) throws -> ResponseRepresentable {
        guard let json = request.json else { throw Abort.badRequest }
        let reply = try PostReply(json: json)
        try reply.delete()
        return reply
    }
    
    
    
    func addRoutes(to routeBuilder: RouteBuilder) {
        
        // /api/v1/postreplies/create
        routeBuilder.post("create", handler: create)
        
        // /api/v1/postreplies/:id
        routeBuilder.patch(PostReply.parameter, handler: update)
        routeBuilder.delete(PostReply.parameter, handler: delete)
        
        // /api/v1/postreplies/comment?id=1
        routeBuilder.get("comment", handler: getByComment)
    }
    
    
    
}
