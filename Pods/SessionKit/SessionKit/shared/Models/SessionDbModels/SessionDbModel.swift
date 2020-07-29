//
//  SessionDbModel.swift
//  SessionKit
//
//  Created by Ferhat Abdullahoglu on 13.11.2018.
//  Copyright © 2018 Ferhat Abdullahoglu. All rights reserved.
//

import Foundation

/**
 Database initialization point for the __Session__ object.
 Includes the minimum init. parameters
 */
public struct SessionDbModel: Equatable {
    /**
     Name of the category the session belongs to
     */
    public let category: String
    
    /**
     Name of the session
     */
    public let name: String
    
    /**
     Premium flag
     */
    public let isPremium: Bool
    
    /**
     Short expression of the session
     */
    public let expressionShort: String
    
    /**
     Long expression of thes session
     */
    public let expressionLong: String
    
    /**
     Subversion of the session
     */
    public var sv = [SubVersionDbModel]()
    
    /**
     Display name
     */
    public var displayName: String?
    
    /**
     ID of the session
     */
    public var id: Double
    
    public init?(data: [String:Any]) {
        guard let _name = data.keys.first else {return nil}
        
        guard let _data = data[_name] as? [String:Any] else {return nil}
        
        guard let _category = _data["category"] as? String else {return nil}
        
        guard let _isPremium = _data["isPremium"] as? Bool else {return nil}
        
        let _expressionLong = _data["expressionLong"] as? String
        
        let _expressionShort = _data["expressionShort"] as? String
        
        let _id = _data["id"] as? Double
        
        let _displayName = _data["displayName"] as? String
        
        guard let _sv = _data["subVersions"] as? [[String:Any]] else {return nil}
        
        for __sv in _sv {
            sv.append(SubVersionDbModel(data: __sv))
        }
        
        self.name = _name
        self.category = _category
        self.isPremium = _isPremium
        self.expressionLong = _expressionLong ?? ""
        self.expressionShort = _expressionShort ?? ""
        self.id = _id ?? 0
        self.displayName = _displayName
    }
}
