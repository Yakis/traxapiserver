//
//  EventsController.swift
//  traxapi
//
//  Created by Mugurel Moscaliuc on 18/10/2017.
//
//

import PostgreSQLProvider

final class EventsController {
    
    fileprivate func getAll(request: Request) throws -> ResponseRepresentable {
        return try Event.all().makeJSON()
    }
    
    
    fileprivate func getOne(request: Request) throws -> ResponseRepresentable {
        let event = try request.parameters.next(Event.self)
        return event
    }
    
    
    fileprivate func getByTrack(request: Request) throws -> ResponseRepresentable {
        guard let track = request.query?["trackid"]?.int else {
            fatalError("Track not found!)")
        }
        let events = try Event.all().filter { $0.track_id == track }
        return try events.makeJSON()
    }
    
    
    fileprivate func create(request: Request) throws -> ResponseRepresentable {
        guard let json = request.json else { throw Abort.badRequest }
        let event = try Event(json: json)
        guard let track = try Track.find(event.track_id) else {throw Abort.badRequest}
        guard let user = try User.find(track.user_id) else {throw Abort.badRequest}
        switch user.userType {
        case "owner":
            try event.save()
            return event
        default: throw Abort.unauthorized
        }
    }
    
    
    fileprivate func update(request: Request) throws -> ResponseRepresentable {
        let event = try request.parameters.next(Event.self)
        guard let json = request.json else { throw Abort.badRequest }
        let newEvent = try Event(json: json)
        event.content = newEvent.content
        event.track_id = newEvent.track_id
        event.event_date = newEvent.event_date
        try event.save()
        return event
    }
    
    
    fileprivate func delete(request: Request) throws -> ResponseRepresentable {
        guard let json = request.json else { throw Abort.badRequest }
        let event = try Event(json: json)
        try event.delete()
        return event
    }
    
    

    
    func addRoutes(to routeBuilder: RouteBuilder) {
        
        // /api/v1/events/all
        routeBuilder.get("all", handler: getAll)
        
        // /api/v1/events/create
        routeBuilder.post("create", handler: create)
        
        // /api/v1/events/:id
        routeBuilder.get(Post.parameter, handler: getOne)
        routeBuilder.patch(Post.parameter, handler: update)
        routeBuilder.delete(Post.parameter, handler: delete)
        
        
        // /events/trackid=1
        routeBuilder.get("", handler: getByTrack)
        
    }
    
    
}
