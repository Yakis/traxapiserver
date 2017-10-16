//
//  User.swift
//  traxapi
//
//  Created by Mugurel Moscaliuc on 23/09/2017.
//
//

import PostgreSQLProvider

final class User: Model {
    
    let storage = Storage()
    var username: String
    var email: String
    var firstName: String
    var lastName: String
    var contactNumber: String
    var postcode: String
    var avatar: String
    var deviceToken: String
    var firebaseUid: String
    var userType: String
    
    
    // Use these keys instead of magic strings
    static let idKey = "id"
    static let usernameKey = "username"
    static let emailKey = "email"
    static let firstNameKey = "first_name"
    static let lastNameKey = "last_name"
    static let contactNumberKey = "contact_number"
    static let postcodeKey = "postcode"
    static let avatarKey = "avatar"
    static let firebaseUidKey = "firebase_uid"
    static let userTypeKey = "user_type"
    static let deviceTokenKey = "device_token"
    
    
    init(username: String,
         email: String,
         firstName: String,
         lastName: String,
         contactNumber: String,
         postcode: String,
         avatar: String,
         deviceToken: String,
         firebaseUid: String,
         userType: String
        ) {
        self.username = username
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.postcode = postcode
        self.avatar = avatar
        self.deviceToken = deviceToken
        self.firebaseUid = firebaseUid
        self.contactNumber = contactNumber
        self.userType = userType
        
    }
    
    
    init(row: Row) throws {
        self.username = try row.get(User.usernameKey)
        self.email = try row.get(User.emailKey)
        self.firstName = try row.get(User.firstNameKey)
        self.lastName = try row.get(User.lastNameKey)
        self.postcode = try row.get(User.postcodeKey)
        self.avatar = try row.get(User.avatarKey)
        self.deviceToken = try row.get(User.deviceTokenKey)
        self.firebaseUid = try row.get(User.firebaseUidKey)
        self.contactNumber = try row.get(User.contactNumberKey)
        self.userType = try row.get(User.userTypeKey)
        
    }
    
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(User.usernameKey, username)
        try row.set(User.emailKey, email)
        try row.set(User.firstNameKey, firstName)
        try row.set(User.lastNameKey, lastName)
        try row.set(User.postcodeKey, postcode)
        try row.set(User.avatarKey, avatar)
        try row.set(User.deviceTokenKey, deviceToken)
        try row.set(User.firebaseUidKey, firebaseUid)
        try row.set(User.contactNumberKey, contactNumber)
        try row.set(User.userTypeKey, userType)
        return row
    }
}
// For database prepare and revert
extension User: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create(self) { (user) in
            user.id()
            user.string(User.usernameKey)
            user.string(User.emailKey)
            user.string(User.firstNameKey)
            user.string(User.lastNameKey)
            user.string(User.postcodeKey)
            user.string(User.avatarKey)
            user.string(User.deviceTokenKey)
            user.string(User.firebaseUidKey)
            user.string(User.contactNumberKey)
            user.string(User.userTypeKey)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

// Convenience of generate model from JSON
extension User: JSONConvertible {
    
    convenience init(json: JSON) throws {
        self.init(username: try json.get(User.usernameKey),
                  email: try json.get(User.emailKey),
                  firstName: try json.get(User.firstNameKey),
                  lastName: try json.get(User.lastNameKey),
                  contactNumber: try json.get(User.contactNumberKey),
                  postcode: try json.get(User.postcodeKey),
                  avatar: try json.get(User.avatarKey),
                  deviceToken: try json.get(User.deviceTokenKey),
                  firebaseUid: try json.get(User.firebaseUidKey),
                  userType: try json.get(User.userTypeKey)
        )}
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(User.idKey, id)
        try json.set(User.usernameKey, username)
        try json.set(User.emailKey, email)
        try json.set(User.firstNameKey, firstName)
        try json.set(User.lastNameKey, lastName)
        try json.set(User.postcodeKey, postcode)
        try json.set(User.avatarKey, avatar)
        try json.set(User.deviceTokenKey, deviceToken)
        try json.set(User.firebaseUidKey, firebaseUid)
        try json.set(User.contactNumberKey, contactNumber)
        try json.set(User.userTypeKey, userType)
        
        return json
    }
}

// Convenience of returning response
extension User: ResponseRepresentable {}

extension User {
    
    var tracks: Children<User, Track> {
        return children()
    }
    
    
    var reviewComments: Children<User, ReviewComment> {
        return children()
    }
    
    
    var settings: Children<User, Setting> {
        return children()
    }
    
    var tokens: Children<User, UserToken> {
        return children()
    }
    
    
    // Parent of:
    var postComments: Children<User, PostComment> {
        return children()
    }
    
    var postReply: Children<User, PostReply> {
        return children()
    }
    
    var postLike: Children<User, PostLike> {
        return children()
    }
    
    
    
    var imageComments: Children<User, ImageComment> {
        return children()
    }
    
    var imageReply: Children<User, ImageReply> {
        return children()
    }
    
    var imageLike: Children<User, ImageLike> {
        return children()
    }
    
    
    
    var videoComments: Children<User, VideoComment> {
        return children()
    }
    
    var videoReply: Children<User, VideoReply> {
        return children()
    }
    
    var videoLike: Children<User, VideoLike> {
        return children()
    }
    

    
    var reviewReply: Children<User, ReviewReply> {
        return children()
    }
    
    
}
