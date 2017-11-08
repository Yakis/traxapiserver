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
        let user = try request.parameters.next(User.self)
        return user
    }
    
    
    fileprivate func getSettings(request: Request) throws -> ResponseRepresentable {
        guard let user_id = request.query?["user_id"]?.int else {
            fatalError("User id not found!)")
        }
        let settings = try Setting.all().filter { $0.user_id == user_id }
        return try settings.makeJSON()
    }
    
    fileprivate func saveSettings(request: Request) throws -> ResponseRepresentable {
        guard let json = request.json else { throw Abort.badRequest }
            let settings = try Setting(json: json)
            try settings.save()
            return try settings.makeJSON()
    }
    
    
    fileprivate func updateSettings(request: Request) throws -> ResponseRepresentable {
        guard let user_id = request.query?["user_id"]?.int else {
            fatalError("User id not found!)")
        }
        let settings = try Setting.all().filter { $0.user_id == user_id }
        guard let setting = settings.first else { throw Abort.notFound }
        guard let json = request.json else { throw Abort.badRequest }
        let newSetting = try Setting(json: json)
        setting.trackUpdate = newSetting.trackUpdate
        setting.tagNotify = newSetting.tagNotify
        setting.locationEnabled = newSetting.locationEnabled
        setting.user_id = newSetting.user_id
        try setting.save()
        return setting
    }
    
    
    fileprivate func searchByName(request: Request) throws -> ResponseRepresentable {
        guard let username = request.query?["username"]?.string else {
            fatalError("Track not found!)")
        }
        let users = try User.all().filter { $0.username.lowercased().contains(username.lowercased()) }
        return try users.makeJSON()
    }
    
    
    fileprivate func create(request: Request) throws -> ResponseRepresentable {
        guard let json = request.json else { throw Abort.badRequest }
        let user = try User(json: json)
        if try User.makeQuery().filter("firebase_uid", user.firebaseUid).first() == nil {
            try user.save()
            return user
        } else {
            return "User already exist"
        }
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
        
        // /api/v1/users/all
        routeBuilder.get("all", handler: getAll)
        
        // /api/v1/users/create
        routeBuilder.post("create", handler: create)
        
        // /api/v1/users/:id
        routeBuilder.get(User.parameter, handler: getOne)
        routeBuilder.patch(User.parameter, handler: update)
        routeBuilder.delete(User.parameter, handler: delete)
        
        // /api/v1/users?username=:username
        routeBuilder.get("", handler: searchByName)
        
        // /api/v1/users/settings?user_id=:id
        routeBuilder.get("settings", handler: getSettings)
        
        // /api/v1/users/settings/create
        routeBuilder.post("settings", "create", handler: saveSettings)
        
        // /api/v1/users/settings?user_id=:id
        routeBuilder.patch("settings", handler: updateSettings)
        
    }
    
    
}
