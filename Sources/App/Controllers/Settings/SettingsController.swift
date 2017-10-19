//
//  SettingsController.swift
//  traxapi
//
//  Created by Mugurel Moscaliuc on 23/09/2017.
//
//

import PostgreSQLProvider

final class SettingsController {
    fileprivate func getAll(request: Request) throws -> ResponseRepresentable {
        return try Setting.all().makeJSON()
    }
    
    
    fileprivate func getOne(request: Request) throws -> ResponseRepresentable {
        let track = try request.parameters.next(Setting.self)
        return track
    }
    
    
    fileprivate func update(request: Request) throws -> ResponseRepresentable {
        let setting = try request.parameters.next(Setting.self)
        guard let json = request.json else { throw Abort.badRequest }
        let newSetting = try Setting(json: json)
        setting.trackUpdate = newSetting.trackUpdate
        setting.tagNotify = newSetting.tagNotify
        setting.locationEnabled = newSetting.locationEnabled
        setting.user_id = newSetting.user_id
        try setting.save()
        return setting
    }
    
    
    fileprivate func delete(request: Request) throws -> ResponseRepresentable {
        guard let json = request.json else { throw Abort.badRequest }
        let track = try Setting(json: json)
        try track.delete()
        return track
    }
    
    
    func addRoutes(to routeBuilder: RouteBuilder) {
        
        // /api/v1/settings/all
        routeBuilder.get("all", handler: getAll)
        
        // /api/v1/settings/:id
        routeBuilder.get(Setting.parameter, handler: getOne)
        routeBuilder.patch(Setting.parameter, handler: update)
        routeBuilder.delete(Setting.parameter, handler: delete)
    }
    
    
}
