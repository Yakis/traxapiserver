//
//  UsersController.swift
//  traxapi
//
//  Created by Mugurel Moscaliuc on 23/09/2017.
//
//

import PostgreSQLProvider

final class UsersController {
    fileprivate func getAll(request: Request) throws -> ResponseRepresentable {
        return try User.all().makeJSON()
    }
    
    
    fileprivate func getOne(request: Request) throws -> ResponseRepresentable {
        let track = try request.parameters.next(User.self)
        return track
    }
    
    
    fileprivate func create(request: Request) throws -> ResponseRepresentable {
        guard let json = request.json else { throw Abort.badRequest }
        let track = try User(json: json)
        try track.save()
        return track
    }
    
    
    fileprivate func update(request: Request) throws -> ResponseRepresentable {
        let user = try request.parameters.next(User.self)
        guard let json = request.json else { throw Abort.badRequest }
        let newUser = try User(json: json)
        user.username = newUser.username
        user.email = newUser.email
        user.firstName = newUser.firstName
        user.lastName = newUser.lastName
        user.contactNumber = newUser.contactNumber
        user.postcode = newUser.postcode
        user.avatar = newUser.avatar
        user.firebaseUid = newUser.firebaseUid
        user.userType = newUser.userType
        user.deviceToken = newUser.deviceToken
        try user.save()
        return user
    }
    
    
    fileprivate func delete(request: Request) throws -> ResponseRepresentable {
        guard let json = request.json else { throw Abort.badRequest }
        let track = try User(json: json)
        try track.delete()
        return track
    }
    
    
    func addRoutes(to routeBuilder: RouteBuilder) {
        routeBuilder.get("all", handler: getAll)
        routeBuilder.post("create", handler: create)
        routeBuilder.get(User.parameter, handler: getOne)
        routeBuilder.patch(User.parameter, handler: update)
        routeBuilder.delete(User.parameter, handler: delete)
    }
    
    
}
