//
//  DKPriveSession+CoreDataProperties.swift
//  SessionKit
//
//  Created by Ferhat Abdullahoglu on 2.12.2018.
//  Copyright © 2018 Ferhat Abdullahoglu. All rights reserved.
//
//

import Foundation
import CoreData


extension DKPriveSession {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DKPriveSession> {
        return NSFetchRequest<DKPriveSession>(entityName: "DKPriveSession")
    }
    
    @NSManaged public var duration: Double
    @NSManaged public var isReleased: Bool
    @NSManaged public var status: Int16
    @NSManaged public var url: String
    
}
