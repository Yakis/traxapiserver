//
//  PostsController.swift
//  traxapi
//
//  Created by Mugurel Moscaliuc on 23/09/2017.
//
//

import PostgreSQLProvider

final class PostsController {
    fileprivate func getAll(request: Request) throws -> ResponseRepresentable {
        return try Post.all().makeJSON()
    }
    
    
    
    
    
    fileprivate func getOne(request: Request) throws -> ResponseRepresentable {
        let post = try request.parameters.next(Post.self)
        return post
    }
    
    
    fileprivate func create(request: Request) throws -> ResponseRepresentable {
        guard let json = request.json else { throw Abort.badRequest }
        let post = try Post(json: json)
        try post.save()
        return post
    }
    
    
    fileprivate func update(request: Request) throws -> ResponseRepresentable {
        guard let json = request.json else { throw Abort.badRequest }
        let post = try Post(json: json)
        try post.save()
        return post
    }
    
    
    fileprivate func delete(request: Request) throws -> ResponseRepresentable {
        guard let json = request.json else { throw Abort.badRequest }
        let post = try Post(json: json)
        try post.delete()
        return post
    }
    
    
    func addRoutes(to routeBuilder: RouteBuilder) {
        routeBuilder.get("all", handler: getAll)
        routeBuilder.post("create", handler: create)
        routeBuilder.get(Post.parameter, handler: getOne)
        routeBuilder.patch(Post.parameter, handler: update)
        routeBuilder.delete(Post.parameter, handler: delete)
    }
    
    
}
