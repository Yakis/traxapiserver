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
    
    
    fileprivate func create(request: Request) throws -> ResponseRepresentable {
        guard let json = request.json else { throw Abort.badRequest }
        let track = try PostComment(json: json)
        try track.save()
        return track
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
        routeBuilder.get("all", handler: getAll)
        routeBuilder.post("create", handler: create)
        routeBuilder.get(PostComment.parameter, handler: getOne)
        routeBuilder.patch(PostComment.parameter, handler: update)
        routeBuilder.delete(PostComment.parameter, handler: delete)
    }
    
    
}
