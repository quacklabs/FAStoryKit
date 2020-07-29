//
//  DKSubversion+CoreDataProperties.swift
//  SessionKit
//
//  Created by Ferhat Abdullahoglu on 1.12.2018.
//  Copyright © 2018 Ferhat Abdullahoglu. All rights reserved.
//
//

import Foundation
import CoreData


extension DKSubversion {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DKSubversion> {
        return NSFetchRequest<DKSubversion>(entityName: "DKSubversion")
    }
    
    @NSManaged public var id: Double
    @NSManaged public var durationRemote: Double
    @NSManaged public var isCompleted: Bool
    @NSManaged public var isFixed: Bool
    @NSManaged public var isPremium: Bool
    @NSManaged public var name: String
    @NSManaged public var parent: DKSession?
    @NSManaged public var source: String? 
    
}
