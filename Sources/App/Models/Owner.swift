//
//  Owner.swift
//  traxapi
//
//  Created by Mugurel Moscaliuc on 23/09/2017.
//
//

import PostgreSQLProvider

final class Owner: Model {
    
    let storage = Storage()
    var email: String
    var firstName: String
    var lastName: String
    var contactNumber: String
    
    
    // Use these keys instead of magic strings
    static let idKey = "id"
    static let emailKey = "email"
    static let firstNameKey = "first_name"
    static let lastNameKey = "last_name"
    static let contactNumberKey = "contact_number"
    
    
    init(email: String,
         firstName: String,
         lastName: String,
         contactNumber: String
        ) {
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.contactNumber = contactNumber
       
    }
    
    
    init(row: Row) throws {
        self.email = try row.get(Owner.emailKey)
        self.firstName = try row.get(Owner.firstNameKey)
        self.lastName = try row.get(Owner.lastNameKey)
        self.contactNumber = try row.get(Owner.contactNumberKey)
        
    }
    
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Owner.emailKey, email)
        try row.set(Owner.firstNameKey, firstName)
        try row.set(Owner.lastNameKey, lastName)
        try row.set(Owner.contactNumberKey, contactNumber)
        return row
    }
}
// For database prepare and revert
extension Owner: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create(self) { (builder) in
            builder.id()
            builder.string(Owner.emailKey)
            builder.string(Owner.firstNameKey)
            builder.string(Owner.lastNameKey)
            builder.string(Owner.contactNumberKey)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

// Convenience of generate model from JSON
extension Owner: JSONConvertible {
    
    convenience init(json: JSON) throws {
        self.init(email: try json.get(Owner.emailKey),
                  firstName: try json.get(Owner.firstNameKey),
                  lastName: try json.get(Owner.lastNameKey),
                  contactNumber: try json.get(Owner.contactNumberKey)
    )}
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Owner.idKey, id)
        try json.set(Owner.emailKey, email)
        try json.set(Owner.firstNameKey, firstName)
        try json.set(Owner.lastNameKey, lastName)
        try json.set(Owner.contactNumberKey, contactNumber)
      
        return json
    }
}

// Convenience of returning response
extension Owner: ResponseRepresentable {}


extension Owner {
    var tracks: Children<Owner, Track> {
        return children()
    }
}
