//
//  VideoController.swift
//  traxapi
//
//  Created by Mugurel Moscaliuc on 10/10/2017.
//
//

import PostgreSQLProvider

final class VideosController {
    fileprivate func getAll(request: Request) throws -> ResponseRepresentable {
        return try Video.all().makeJSON()
    }
    
    
    fileprivate func getOne(request: Request) throws -> ResponseRepresentable {
        let video = try request.parameters.next(Video.self)
        return video
    }
    
    
    fileprivate func create(request: Request) throws -> ResponseRepresentable {
        guard let json = request.json else { throw Abort.badRequest }
        let video = try Video(json: json)
        try video.save()
        return video
    }
    
    
    fileprivate func update(request: Request) throws -> ResponseRepresentable {
        let video = try request.parameters.next(Video.self)
        guard let json = request.json else { throw Abort.badRequest }
        let newVideo = try Video(json: json)
        video.videoUrl = newVideo.videoUrl
        video.track_id = newVideo.track_id
        try video.save()
        return video
    }
    
    
    fileprivate func delete(request: Request) throws -> ResponseRepresentable {
        guard let json = request.json else { throw Abort.badRequest }
        let video = try Video(json: json)
        try video.delete()
        return video
    }
    
    
    fileprivate func getLikesCount(request: Request) throws -> ResponseRepresentable {
        guard let video = request.query?["id"]?.int else {
            fatalError("Post not found!)")
        }
        let likes = try VideoLike.all().filter { $0.video_id == video }
        return "\(likes.count)"
    }
    
    
    fileprivate func isLiked(request: Request) throws -> ResponseRepresentable {
        guard let user = request.query?["user_id"]?.int else {
            fatalError("Post not found!)")
        }
        guard let video = request.query?["video_id"]?.int else {
            fatalError("Post not found!)")
        }
        let likes = try VideoLike.all().filter { $0.video_id == video && $0.user_id == user }
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
        let like = try VideoLike(json: json)
        try like.save()
        return like
    }
    
    
    
    func addRoutes(to routeBuilder: RouteBuilder) {
        routeBuilder.get("all", handler: getAll)
        routeBuilder.post("create", handler: create)
        routeBuilder.get(Video.parameter, handler: getOne)
        routeBuilder.patch(Video.parameter, handler: update)
        routeBuilder.delete(Video.parameter, handler: delete)
        
        // /api/v1/videos/likes/create
        routeBuilder.post("likes", "create", handler: like)
        
        // /api/v1/videos/likes/video?id=:id
        routeBuilder.get("likes", "video", handler: getLikesCount)
        
        // /api/v1/videos/likes?user_id=:id&video_id=:id
        routeBuilder.get("likes", handler: isLiked)
    }
    
    
}
