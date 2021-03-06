//
//  ImagesController.swift
//  traxapi
//
//  Created by Mugurel Moscaliuc on 23/09/2017.
//
//

import PostgreSQLProvider

final class ImagesController {
    fileprivate func getAll(request: Request) throws -> ResponseRepresentable {
        return try Image.all().makeJSON()
    }
    
    
    fileprivate func getOne(request: Request) throws -> ResponseRepresentable {
        let track = try request.parameters.next(Image.self)
        return track
    }
    
    
    fileprivate func create(request: Request) throws -> ResponseRepresentable {
        guard let json = request.json else { throw Abort.badRequest }
        let track = try Image(json: json)
        try track.save()
        return track
    }
    
    
    fileprivate func update(request: Request) throws -> ResponseRepresentable {
        let image = try request.parameters.next(Image.self)
        guard let json = request.json else { throw Abort.badRequest }
        let newImage = try Image(json: json)
        image.imageUrl = newImage.imageUrl
        image.track_id = newImage.track_id
        try image.save()
        return image
    }
    
    
    fileprivate func delete(request: Request) throws -> ResponseRepresentable {
        guard let json = request.json else { throw Abort.badRequest }
        let track = try Image(json: json)
        try track.delete()
        return track
    }
    
    
    fileprivate func getLikesCount(request: Request) throws -> ResponseRepresentable {
        guard let image = request.query?["id"]?.int else {
            fatalError("Post not found!)")
        }
        let likes = try ImageLike.all().filter { $0.image_id == image }
        return "\(likes.count)"
    }
    
    
    fileprivate func isLiked(request: Request) throws -> ResponseRepresentable {
        guard let user = request.query?["user_id"]?.int else {
            fatalError("Post not found!)")
        }
        guard let image = request.query?["image_id"]?.int else {
            fatalError("Post not found!)")
        }
        let likes = try ImageLike.all().filter { $0.image_id == image && $0.user_id == user }
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
        let like = try ImageLike(json: json)
        try like.save()
        return like
    }
    
    
    
    func addRoutes(to routeBuilder: RouteBuilder) {
        
        // /api/v1/images/all
        routeBuilder.get("all", handler: getAll)
        
        // /api/v1/images/create
        routeBuilder.post("create", handler: create)
        
        // /api/v1/images/:id
        routeBuilder.get(Image.parameter, handler: getOne)
        routeBuilder.patch(Image.parameter, handler: update)
        routeBuilder.delete(Image.parameter, handler: delete)
        
        
        // /api/v1/images/likes/create
        routeBuilder.post("likes", "create", handler: like)
        
        // /api/v1/images/likes/image?id=1
        routeBuilder.get("likes", "image", handler: getLikesCount)
        
        // /api/v1/images/likes?user_id=1&image_id=1
        routeBuilder.get("likes", handler: isLiked)
    }
    
    
}
