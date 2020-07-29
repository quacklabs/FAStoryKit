//
//  DKCategory+CoreDataClass.swift
//  SessionKit
//
//  Created by Ferhat Abdullahoglu on 1.12.2018.
//  Copyright © 2018 Ferhat Abdullahoglu. All rights reserved.
//
//

import Foundation
import CoreData

@objc(DKCategory)
open class DKCategory: NSManagedObject {
    
    /* ==================================================== */
    /* MARK: Properties                                     */
    /* ==================================================== */
    
    // -----------------------------------
    // Public properties
    // -----------------------------------
    
    // -----------------------------------
    
    
    // -----------------------------------
    // Private properties
    // -----------------------------------
    
    // -----------------------------------
    
    
    /* ==================================================== */
    /* MARK: Init                                           */
    /* ==================================================== */
    public convenience init?(name: String, id: Int, isDefault: Bool = false) {
        
        let _moc = DKSessionDataHandler.default.managedObjectContext
        
        guard let _category = NSEntityDescription.entity(forEntityName: NSStringFromClass(DKCategory.self), in: _moc) else {return nil}
        
        self.init(entity: _category, insertInto: _moc)
        
        self.categoryName = name
        self.hasNewMember = false
        self.imageData = nil
        self.rawImageData = nil 
        self.id = Int16(id)
        self.wasUsedLatest = isDefault
        self.imageAverageColor = nil
        self.isSpecial = false 
    }
    
    
    public convenience init() {
        self.init(name: "", id: 0)!
    }
    /* ==================================================== */
    /* MARK: Methods                                        */
    /* ==================================================== */
    
    // -----------------------------------
    // Public methods
    // -----------------------------------
    
    // -----------------------------------
    
    
    // -----------------------------------
    // Private methods
    // -----------------------------------
    
    // -----------------------------------
    
}
