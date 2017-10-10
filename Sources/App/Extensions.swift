//
//  Extensions.swift
//  traxapi
//
//  Created by Mugurel Moscaliuc on 10/10/2017.
//
//

import Foundation
import FluentProvider


extension Timestampable {
    
    var formattedCreatedAt: String? {
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 3600)
        formatter.locale = Locale(identifier: "en_UK")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return createdAt.map { formatter.string(from: $0) }
    }
    
    var formattedUpdatedAt: String? {
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 3600)
        formatter.locale = Locale(identifier: "en_UK")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return updatedAt.map { formatter.string(from: $0) }
    }
    
}
