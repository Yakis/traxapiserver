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
        guard let json = request.json else { throw Abort.badRequest }
        let track = try Image(json: json)
        try track.save()
        return track
    }
    
    
    fileprivate func delete(request: Request) throws -> ResponseRepresentable {
        guard let json = request.json else { throw Abort.badRequest }
        let track = try Image(json: json)
        try track.delete()
        return track
    }
    
    
    func addRoutes(to routeBuilder: RouteBuilder) {
//        routeBuilder.get("all", handler: getAll)
//        routeBuilder.post("create", handler: create)
//        routeBuilder.get(Image.parameter, handler: getOne)
//        routeBuilder.patch(Image.parameter, handler: update)
//        routeBuilder.delete(Image.parameter, handler: delete)
    }
    
    
}
