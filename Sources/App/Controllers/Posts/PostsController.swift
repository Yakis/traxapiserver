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
        guard let track = try Track.find(post.track_id) else {throw Abort.badRequest}
        guard let user = try User.find(track.user_id) else {throw Abort.badRequest}
        switch user.userType {
        case "owner":
            try post.save()
            return post
        default: throw Abort.unauthorized
        }
    }
    
    
    fileprivate func update(request: Request) throws -> ResponseRepresentable {
        let post = try request.parameters.next(Post.self)
        guard let json = request.json else { throw Abort.badRequest }
        let newPost = try Post(json: json)
        post.content = newPost.content
        post.track_id = newPost.track_id
        post.image = newPost.image
        try post.save()
        return post
    }
    
    
    fileprivate func delete(request: Request) throws -> ResponseRepresentable {
        guard let json = request.json else { throw Abort.badRequest }
        let post = try Post(json: json)
        try post.delete()
        return post
    }
    
    
    fileprivate func getLikesCount(request: Request) throws -> ResponseRepresentable {
        guard let post = request.query?["id"]?.int else {
            fatalError("Post not found!)")
        }
        let likes = try PostLike.all().filter { $0.post_id == post }
        return "\(likes.count)"
    }
    
    
    fileprivate func isLiked(request: Request) throws -> ResponseRepresentable {
        guard let user = request.query?["user_id"]?.int else {
            fatalError("Post not found!)")
        }
        guard let post = request.query?["post_id"]?.int else {
            fatalError("Post not found!)")
        }
        let likes = try PostLike.all().filter { $0.post_id == post && $0.user_id == user }
        if likes.count > 0 {
            var json = JSON()
            try json.set("isLiked", true)
            return json
        } else {
            var json = JSON()
            try json.set("isLiked", false)
            return json
        }
    }
    
    
    fileprivate func like(request: Request) throws -> ResponseRepresentable {
        guard let json = request.json else { throw Abort.badRequest }
        let like = try PostLike(json: json)
        try like.save()
        return like
    }
    
    
    func addRoutes(to routeBuilder: RouteBuilder) {
        
        // /api/v1/posts/all
        routeBuilder.get("all", handler: getAll)
        // /api/v1/posts/create
        routeBuilder.post("create", handler: create)
        
        // /api/v1/posts/:id
        routeBuilder.get(Post.parameter, handler: getOne)
        routeBuilder.patch(Post.parameter, handler: update)
        routeBuilder.delete(Post.parameter, handler: delete)
        
        // /api/v1/posts/likes/create
        routeBuilder.post("likes", "create", handler: like)
        
        // /api/v1/posts/likes/post?id=1
        routeBuilder.get("likes", "post", handler: getLikesCount)
        
        // /api/v1/posts/likes?user_id=1&post_id=1
        routeBuilder.get("likes", handler: isLiked)
    }
    
    
}
