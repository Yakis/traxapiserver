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
        guard let json = request.json else { throw Abort.badRequest }
        let video = try Video(json: json)
        try video.save()
        return video
    }
    
    
    fileprivate func delete(request: Request) throws -> ResponseRepresentable {
        guard let json = request.json else { throw Abort.badRequest }
        let video = try Video(json: json)
        try video.delete()
        return video
    }
    
    
    func addRoutes(to routeBuilder: RouteBuilder) {
        routeBuilder.get("all", handler: getAll)
        routeBuilder.post("create", handler: create)
        routeBuilder.get(Video.parameter, handler: getOne)
        routeBuilder.patch(Video.parameter, handler: update)
        routeBuilder.delete(Video.parameter, handler: delete)
    }
    
    
}
