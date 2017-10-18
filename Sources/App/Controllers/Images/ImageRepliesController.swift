//
//  ImageRepliesController.swift
//  traxapi
//
//  Created by Mugurel Moscaliuc on 10/10/2017.
//
//

import PostgreSQLProvider

final class ImageRepliesController {
    
    
    fileprivate func getByComment(request: Request) throws -> ResponseRepresentable {
        guard let comment = request.query?["id"]?.int else {
            fatalError("Comment not found!)")
        }
        let replies = try ImageReply.all().filter { $0.image_comment_id == comment }
        return try replies.makeJSON()
    }
    
    
    fileprivate func create(request: Request) throws -> ResponseRepresentable {
        guard let json = request.json else { throw Abort.badRequest }
        let reply = try ImageReply(json: json)
        try reply.save()
        return reply
    }
    
    
    fileprivate func update(request: Request) throws -> ResponseRepresentable {
        let imageReply = try request.parameters.next(ImageReply.self)
        guard let json = request.json else { throw Abort.badRequest }
        let newImageReply = try ImageReply(json: json)
        imageReply.content = newImageReply.content
        imageReply.image_comment_id = newImageReply.image_comment_id
        try imageReply.save()
        return imageReply
    }
    
    
    fileprivate func delete(request: Request) throws -> ResponseRepresentable {
        guard let json = request.json else { throw Abort.badRequest }
        let reply = try ImageReply(json: json)
        try reply.delete()
        return reply
    }
    
    
    
    func addRoutes(to routeBuilder: RouteBuilder) {
        
        // /api/v1/imagereplies/create
        routeBuilder.post("create", handler: create)
        
        // /api/v1/imagereplies/:id
        routeBuilder.patch(ImageReply.parameter, handler: update)
        routeBuilder.delete(ImageReply.parameter, handler: delete)
        
        // /api/v1/imagereplies/comment?id=1
        routeBuilder.get("comment", handler: getByComment)
    }
    
    
}
