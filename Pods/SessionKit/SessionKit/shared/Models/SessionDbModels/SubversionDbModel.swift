//
//  SubversionDbModel.swift
//  SessionKit
//
//  Created by Ferhat Abdullahoglu on 13.11.2018.
//  Copyright © 2018 Ferhat Abdullahoglu. All rights reserved.
//

import Foundation


/**
 Database model for the subVersion type
 */
public struct SubVersionDbModel: Equatable {
    
    /**
     Name of the session
     */
    public let name: String
    
    /**
     Premium flag
     */
    public let isPremium: Bool
    
    /**
     Session UID
     */
    public let id: Int
    
    /**
     Session source
     */
    public let source: String
    
    /**
     Duration of the session
     */
    public let duration: Double
    
    init(data: [String:Any]) {
        name = data["name"] as? String ?? "sv name"
        
        isPremium = data["isPremium"] as? Bool ?? false
        
        id = data["id"] as? Int ?? 1000
        
        source = data["source"] as? String ?? "sv source"
        
        duration = data["duration"] as? Double ?? 0
    }
    
    public init()  {
        name = ""
        isPremium = false
        id = 0
        duration = 0
        source = ""
    }

    static public func ==(lhs: SubVersionDbModel, rhs: SubVersionDbModel) -> Bool {
        return lhs.name == rhs.name &&
            lhs.id == rhs.id &&
            lhs.source == rhs.source &&
            lhs.duration == rhs.duration
    }
}

