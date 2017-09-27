//
//  TracksController.swift
//  traxapi
//
//  Created by Mugurel Moscaliuc on 23/09/2017.
//
//

import PostgreSQLProvider

final class TracksController {
    fileprivate func getAll(request: Request) throws -> ResponseRepresentable {
        return try Track.all().makeJSON()
    }
    
    fileprivate func getByName(request: Request) throws -> ResponseRepresentable {
        guard let name = request.query?["name"]?.string else {
            fatalError("Track not found!)")
        }
        let tracks = try Track.all().filter { $0.name.lowercased().contains(name.lowercased()) }
        return try tracks.makeJSON()
    }
    
    fileprivate func getOne(request: Request) throws -> ResponseRepresentable {
        let track = try request.parameters.next(Track.self)
        return track
    }
    
    
    fileprivate func create(request: Request) throws -> ResponseRepresentable {
        guard let json = request.json else { throw Abort.badRequest }
        let track = try Track(json: json)
        try track.save()
        return track
    }
    
    
    fileprivate func update(request: Request) throws -> ResponseRepresentable {
        guard let json = request.json else { throw Abort.badRequest }
        let track = try request.parameters.next(Track.self)
        let newTrack = try Track(json: json)
        track.name = newTrack.name
        track.adress = newTrack.adress
        track.childFriendly = newTrack.childFriendly
        track.latitude = newTrack.latitude
        track.longitude = newTrack.longitude
        track.openingTimes = newTrack.openingTimes
        track.ownerId = newTrack.ownerId
        track.postcode = newTrack.postcode
        track.prices = newTrack.prices
        track.rating = newTrack.rating
        track.soilType = newTrack.soilType
        try track.save()
        return track
    }
    
    
    fileprivate func delete(request: Request) throws -> ResponseRepresentable {
        guard let json = request.json else { throw Abort.badRequest }
        let track = try Track(json: json)
        try track.delete()
        return track
    }
    
    
    fileprivate func getImages(request: Request) throws -> ResponseRepresentable {
        let track = try request.parameters.next(Track.self)
        let images = try track.images.all().makeJSON()
        return images
    }
    
    
    fileprivate func saveImage(request: Request) throws -> ResponseRepresentable {
        guard let json = request.json else { throw Abort.badRequest }
        let trackId = request.parameters.wrapped["track_id"]?.int
        print("Track ID==== \(trackId! + 5 )")
       // let track = try request.parameters.next(Track.self)
        let image = try Image(json: json)
        image.track_id = trackId!
        print(image.track_id.description)
        try image.save()
        return image
    }
    
    
    func addRoutes(to routeBuilder: RouteBuilder) {
        routeBuilder.get("all", handler: getAll)
        routeBuilder.post("create", handler: create)
        routeBuilder.get(Track.parameter, handler: getOne)
        routeBuilder.patch(Track.parameter, handler: update)
        routeBuilder.delete(Track.parameter, handler: delete)
        routeBuilder.get("", handler: getByName)
        
        //Child routes
        routeBuilder.post(Track.parameter, "images", handler: saveImage)
        routeBuilder.get(Track.parameter, "images", handler: getImages)
        
//        let adminMiddleware = AdminMiddleware()
//        let adminProtected = routeBuilder.grouped(adminMiddleware)
//        adminProtected.post("create", handler: create)
    }
    
    
}


extension Request {
    fileprivate func track() throws -> Track {
        guard let json = json else { throw Abort.badRequest }
        return try Track(json: json)
    }
}
