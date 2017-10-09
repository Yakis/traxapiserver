//
//  CommentsController.swift
//  traxapi
//
//  Created by Mugurel Moscaliuc on 23/09/2017.
//
//

import PostgreSQLProvider

final class PostsCommentsController {
    
    fileprivate func getAll(request: Request) throws -> ResponseRepresentable {
        return try PostComment.all().makeJSON()
    }
    
    
    fileprivate func getOne(request: Request) throws -> ResponseRepresentable {
        let track = try request.parameters.next(PostComment.self)
        return track
    }
    
    
    fileprivate func getByUser(request: Request) throws -> ResponseRepresentable {
        guard let user = request.query?["id"]?.int else {
            fatalError("Comment not found!)")
        }
        let comments = try PostComment.all().filter { $0.user_id == user }
        return try comments.makeJSON()
    }
    
    
    fileprivate func getByPost(request: Request) throws -> ResponseRepresentable {
        guard let post = request.query?["id"]?.int else {
            fatalError("Comment not found!)")
        }
        let comments = try PostComment.all().filter { $0.post_id == post }
        return try comments.makeJSON()
    }
    
    
    fileprivate func create(request: Request) throws -> ResponseRepresentable {
        guard let json = request.json else { throw Abort.badRequest }
        let comment = try PostComment(json: json)
        try comment.save()
        return comment
    }
    
    
    fileprivate func update(request: Request) throws -> ResponseRepresentable {
        guard let json = request.json else { throw Abort.badRequest }
        let track = try PostComment(json: json)
        try track.save()
        return track
    }
    
    
    fileprivate func delete(request: Request) throws -> ResponseRepresentable {
        guard let json = request.json else { throw Abort.badRequest }
        let track = try PostComment(json: json)
        try track.delete()
        return track
    }
    
    
    func addRoutes(to routeBuilder: RouteBuilder) {
        
        // /api/v1/postcomments/all
        routeBuilder.get("all", handler: getAll)
        
        // /api/v1/postcomments/create
        routeBuilder.post("create", handler: create)
        
        // /api/v1/postcomments/:id
        routeBuilder.get(PostComment.parameter, handler: getOne)
        routeBuilder.patch(PostComment.parameter, handler: update)
        routeBuilder.delete(PostComment.parameter, handler: delete)
        
        // /api/v1/postcomments/user?id=1
        routeBuilder.get("user", handler: getByUser)
        
        // /api/v1/postcomments/post?id=1
        routeBuilder.get("post", handler: getByPost)
    }
    
    
}
