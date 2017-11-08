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
        
        
        
        let users = v1.grouped("users")
        let tracks = v1.grouped("tracks")
        let posts = v1.grouped("posts")
        let postComments = v1.grouped("postcomments")
        let postreplies = v1.grouped("postreplies")
        let images = v1.grouped("images")
        let imageComments = v1.grouped("imagecomments")
        let imageReplies = v1.grouped("imagereplies")
        let videos = v1.grouped("videos")
        let videoComments = v1.grouped("videocomments")
        let videoReplies = v1.grouped("videoreplies")
        let events = v1.grouped("events")
        
        
        let tracksController = TracksController()
        tracksController.addRoutes(to: tracks)
        
        let usersController = UsersController()
        usersController.addRoutes(to: users)
        
        let postsController = PostsController()
        postsController.addRoutes(to: posts)
        
        let postCommentsController = PostCommentsController()
        postCommentsController.addRoutes(to: postComments)
        
        let postRepliesController = PostRepliesController()
        postRepliesController.addRoutes(to: postreplies)
        
        let imagesController = ImagesController()
        imagesController.addRoutes(to: images)
        
        let imageCommentsController = ImageCommentsController()
        imageCommentsController.addRoutes(to: imageComments)
        
        let imageRepliesController = ImageRepliesController()
        imageRepliesController.addRoutes(to: imageReplies)
        
        let videosController = VideosController()
        videosController.addRoutes(to: videos)
        
        let videoCommentsController = VideoCommentsController()
        videoCommentsController.addRoutes(to: videoComments)
        
        let videoRepliesController = VideoRepliesController()
        videoRepliesController.addRoutes(to: videoReplies)
        
        let eventsController = EventsController()
        eventsController.addRoutes(to: events)
        
        
    }
    
}
