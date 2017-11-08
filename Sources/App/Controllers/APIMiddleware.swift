//
//  AuthMiddleware.swift
//  traxapiPackageDescription
//
//  Created by Mugurel Moscaliuc on 08/11/2017.
//

import HTTP
import Vapor

final class APIMiddleware: Middleware {
    
    
    func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        guard let authHeader = request.headers["Authorization"]?.string else { // (4)
            throw Abort.unauthorized
        }
        guard let user = try User.makeQuery().filter("firebase_uid", authHeader).first() else {
            throw Abort.unauthorized
        }
        print("Welcome, \(user.firstName)")
        return try next.respond(to: request)
    }
}
    

