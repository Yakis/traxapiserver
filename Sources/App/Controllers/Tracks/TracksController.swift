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
    
    fileprivate func getByUser(request: Request) throws -> ResponseRepresentable {
        guard let user = request.query?["userid"]?.int else {
            fatalError("Track not found!)")
        }
        let tracks = try Track.all().filter { $0.user_id == user }
        return try tracks.makeJSON()
    }
    
    
    fileprivate func getOne(request: Request) throws -> ResponseRepresentable {
        let track = try request.parameters.next(Track.self)
        return track
    }
    
    
    fileprivate func create(request: Request) throws -> ResponseRepresentable {
        guard let json = request.json else { throw Abort.badRequest }
        guard let images = json[Image.imagesKey]?.array else { throw Abort.badRequest }
        let track = try Track(json: json)
        guard let user = try User.find(track.user_id) else {throw Abort.badRequest}
        switch user.userType {
        case "owner":
            try track.save()
            guard let trackId = track.id?.int else { throw Abort.badRequest }
            for imageUrl in images {
                try saveImage(for: trackId, imageUrl: imageUrl.string!)
            }
            return track
        default: throw Abort.unauthorized
        }
    }
    
    
    fileprivate func update(request: Request) throws -> ResponseRepresentable {
        guard let json = request.json else { throw Abort.badRequest }
        let track = try request.parameters.next(Track.self)
        let newTrack = try Track(json: json)
        track.name = newTrack.name
        track.adress = newTrack.adress
        track.child_friendly = newTrack.child_friendly
        track.latitude = newTrack.latitude
        track.featured = newTrack.featured
        track.longitude = newTrack.longitude
        track.opening_times = newTrack.opening_times
        track.user_id = newTrack.user_id
        track.postcode = newTrack.postcode
        track.prices = newTrack.prices
        track.rating = newTrack.rating
        track.soil_type = newTrack.soil_type
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
    
    
    fileprivate func saveImage(for trackId: Int, imageUrl: String) throws {
        let image = Image(imageUrl: imageUrl, track_id: trackId)
        try image.save()
    }
    
    
    func addRoutes(to routeBuilder: RouteBuilder) {
        
        // /api/v1/tracks/all
        routeBuilder.get("all", handler: getAll)
        
        // /api/v1/tracks/create
        routeBuilder.post("create", handler: create)
        
        // /api/v1/tracks/:id
        routeBuilder.get(Track.parameter, handler: getOne)
        routeBuilder.patch(Track.parameter, handler: update)
        routeBuilder.delete(Track.parameter, handler: delete)
        routeBuilder.get("", handler: getByName)
        
        // /api/v1/tracks/userid=1
        routeBuilder.get("", handler: getByUser)
        
        // /api/v1/tracks/:id/images
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
