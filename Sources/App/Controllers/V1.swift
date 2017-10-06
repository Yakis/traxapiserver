//
//  V1.swift
//  traxapi
//
//  Created by Mugurel Moscaliuc on 23/09/2017.
//
//

import HTTP
import Vapor


class V1: RouteCollection {
    
    func build(_ builder: RouteBuilder) throws {
        let v1 = builder.grouped("api", "v1")
        
        let tracks = v1.grouped("tracks")
        let owners = v1.grouped("owners")
        let users = v1.grouped("users")
        let posts = v1.grouped("posts")
        let comments = v1.grouped("comments")
        let settings = v1.grouped("settings")
        let images = v1.grouped("images")
        
        let tracksController = TracksController()
        tracksController.addRoutes(to: tracks)
        
        let ownersController = OwnersController()
        ownersController.addRoutes(to: owners)
        
        let usersController = UsersController()
        usersController.addRoutes(to: users)
        
        let postsController = PostsController()
        postsController.addRoutes(to: posts)
        
        let postsCommentsController = PostsCommentsController()
        postsCommentsController.addRoutes(to: comments)
        
        let settingsController = SettingsController()
        settingsController.addRoutes(to: settings)
        
        let imagesController = ImagesController()
        imagesController.addRoutes(to: images)
        
    }
    
}
