//
//  DKSessionTheme+CoreDataProperties.swift
//  SessionKit
//
//  Created by Ferhat Abdullahoglu on 15.12.2018.
//  Copyright © 2018 Ferhat Abdullahoglu. All rights reserved.
//
//

import Foundation
import CoreData


extension DKSessionTheme {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DKSessionTheme> {
        return NSFetchRequest<DKSessionTheme>(entityName: "DKSessionTheme")
    }

    @NSManaged public var imageName: String?
    @NSManaged public var displayName: String
    
    

}
