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
    var postcode: String
    var avatar: String
    var facebookUid: String
    
    
    // Use these keys instead of magic strings
    static let idKey = "id"
    static let usernameKey = "username"
    static let emailKey = "email"
    static let firstNameKey = "first_name"
    static let lastNameKey = "last_name"
    static let postcodeKey = "postcode"
    static let avatarKey = "avatar"
    static let facebookUidKey = "facebook_uid"
    
    
    init(username: String,
         email: String,
         firstName: String,
         lastName: String,
         postcode: String,
         avatar: String,
         facebookUid: String
        ) {
        self.username = username
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.postcode = postcode
        self.avatar = avatar
        self.facebookUid = facebookUid
        
    }
    
    
    init(row: Row) throws {
        self.username = try row.get(User.usernameKey)
        self.email = try row.get(User.emailKey)
        self.firstName = try row.get(User.firstNameKey)
        self.lastName = try row.get(User.lastNameKey)
        self.postcode = try row.get(User.postcodeKey)
        self.avatar = try row.get(User.avatarKey)
        self.facebookUid = try row.get(User.facebookUidKey)
        
    }
    
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(User.usernameKey, username)
        try row.set(User.emailKey, email)
        try row.set(User.firstNameKey, firstName)
        try row.set(User.lastNameKey, lastName)
        try row.set(User.postcodeKey, postcode)
        try row.set(User.avatarKey, avatar)
        try row.set(User.facebookUidKey, facebookUid)
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
            user.string(User.facebookUidKey)
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
                  postcode: try json.get(User.postcodeKey),
                  avatar: try json.get(User.avatarKey),
                  facebookUid: try json.get(User.facebookUidKey)
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
        try json.set(User.facebookUidKey, facebookUid)
        
        return json
    }
}

// Convenience of returning response
extension User: ResponseRepresentable {}

extension User {
    var settings: Children<User, Setting> {
        return children()
    }
    
    var comments: Children<User, Comment> {
        return children()
    }
    
    
    var tokens: Children<User, UserToken> {
        return children()
    }
    
}
