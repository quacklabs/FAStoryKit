//
//  DKSubversion+CoreDataClass.swift
//  SessionKit
//
//  Created by Ferhat Abdullahoglu on 1.12.2018.
//  Copyright © 2018 Ferhat Abdullahoglu. All rights reserved.
//
//

import Foundation
import CoreData

@objc(DKSubversion)
open class DKSubversion: NSManagedObject {
    
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
    /**
     Initializes an abstract __DKSubversion__ object
     
     Keep in mind that hereby initialized objects are not saved to the
     context. The save operation must be carried out seperately
     
     - parameters:
     - name: Name of the new subversion
     - returns:
     */
    public convenience init?(name: String) {
        
        let _moc = DKSessionDataHandler.default.managedObjectContext
        
        guard let _subversion = NSEntityDescription.entity(forEntityName: NSStringFromClass(DKSubversion.self), in: _moc) else {return nil}
        
        self.init(entity: _subversion, insertInto: _moc)
        
        self.name = name
        self.isCompleted = false
        self.id = 0
    }
    
    /**
     Initializes a __DKSubversion__ object from a __SubversionDbModel__ struct
     - parameters:
     - data: __SubversionDbModel__
     - returns: __DKSubversion__?
     */
    public convenience init?(data: SubVersionDbModel) {
        self.init(name: data.name)
        self.durationRemote = data.duration
        self.isCompleted = false
        self.id = Double(data.id)
        self.source = data.source
        self.isPremium = data.isPremium
        self.isFixed = false
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
