//
//  VideoCommentsController.swift
//  traxapi
//
//  Created by Mugurel Moscaliuc on 10/10/2017.
//
//

import PostgreSQLProvider

final class VideoCommentsController {
    
    fileprivate func getAll(request: Request) throws -> ResponseRepresentable {
        return try VideoComment.all().makeJSON()
    }
    
    
    fileprivate func getOne(request: Request) throws -> ResponseRepresentable {
        let comment = try request.parameters.next(VideoComment.self)
        return comment
    }
    
    
    fileprivate func getByVideo(request: Request) throws -> ResponseRepresentable {
        guard let video = request.query?["id"]?.int else {
            fatalError("Comment not found!)")
        }
        let comments = try VideoComment.all().filter { $0.video_id == video }
        return try comments.makeJSON()
    }
    
    
    fileprivate func create(request: Request) throws -> ResponseRepresentable {
        guard let json = request.json else { throw Abort.badRequest }
        let comment = try VideoComment(json: json)
        try comment.save()
        return comment
    }
    
    
    fileprivate func update(request: Request) throws -> ResponseRepresentable {
        guard let json = request.json else { throw Abort.badRequest }
        let comment = try VideoComment(json: json)
        try comment.save()
        return comment
    }
    
    
    fileprivate func delete(request: Request) throws -> ResponseRepresentable {
        guard let json = request.json else { throw Abort.badRequest }
        let comment = try VideoComment(json: json)
        try comment.delete()
        return comment
    }
    
    
    func addRoutes(to routeBuilder: RouteBuilder) {
        
        // /api/v1/videocomments/all
        routeBuilder.get("all", handler: getAll)
        
        // /api/v1/videocomments/create
        routeBuilder.post("create", handler: create)
        
        // /api/v1/videocomments/:id
        routeBuilder.get(VideoComment.parameter, handler: getOne)
        routeBuilder.patch(VideoComment.parameter, handler: update)
        routeBuilder.delete(VideoComment.parameter, handler: delete)
        
        // /api/v1/videocomments/video?id=1
        routeBuilder.get("video", handler: getByVideo)
    }
    
    
}
