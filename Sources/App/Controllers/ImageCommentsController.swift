//
//  ImageCommentController.swift
//  traxapi
//
//  Created by Mugurel Moscaliuc on 10/10/2017.
//
//

import PostgreSQLProvider

final class ImageCommentsController {
    
    fileprivate func getAll(request: Request) throws -> ResponseRepresentable {
        return try ImageComment.all().makeJSON()
    }
    
    
    fileprivate func getOne(request: Request) throws -> ResponseRepresentable {
        let comment = try request.parameters.next(ImageComment.self)
        return comment
    }
    
    
    fileprivate func getByImage(request: Request) throws -> ResponseRepresentable {
        guard let image = request.query?["id"]?.int else {
            fatalError("Comment not found!)")
        }
        let comments = try ImageComment.all().filter { $0.image_id == image }
        return try comments.makeJSON()
    }
    
    
    fileprivate func create(request: Request) throws -> ResponseRepresentable {
        guard let json = request.json else { throw Abort.badRequest }
        let comment = try ImageComment(json: json)
        try comment.save()
        return comment
    }
    
    
    fileprivate func update(request: Request) throws -> ResponseRepresentable {
        guard let json = request.json else { throw Abort.badRequest }
        let comment = try ImageComment(json: json)
        try comment.save()
        return comment
    }
    
    
    fileprivate func delete(request: Request) throws -> ResponseRepresentable {
        guard let json = request.json else { throw Abort.badRequest }
        let comment = try ImageComment(json: json)
        try comment.delete()
        return comment
    }
    
    
    func addRoutes(to routeBuilder: RouteBuilder) {
        
        // /api/v1/imagecomments/all
        routeBuilder.get("all", handler: getAll)
        
        // /api/v1/imagecomments/create
        routeBuilder.post("create", handler: create)
        
        // /api/v1/imagecomments/:id
        routeBuilder.get(ImageComment.parameter, handler: getOne)
        routeBuilder.patch(ImageComment.parameter, handler: update)
        routeBuilder.delete(ImageComment.parameter, handler: delete)
        
        // /api/v1/imagecomments/image?id=1
        routeBuilder.get("image", handler: getByImage)
    }
    
    
}
