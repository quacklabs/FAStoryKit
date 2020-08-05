//
//  DKPriveSession+CoreDataClass.swift
//  SessionKit
//
//  Created by Ferhat Abdullahoglu on 2.12.2018.
//  Copyright © 2018 Ferhat Abdullahoglu. All rights reserved.
//
//

import Foundation
import CoreData

@objc(DKPriveSession)
open class DKPriveSession: DKSession {
    /* ==================================================== */
    /* MARK: Properties                                     */
    /* ==================================================== */
    
    // -----------------------------------
    // Public properties
    // -----------------------------------
    open override var categoryName: String? {
        return "Prive".getLocalized()
    }
    // -----------------------------------
    
    
    // -----------------------------------
    // Private properties
    // -----------------------------------
    
    // -----------------------------------
    
    
    /* ==================================================== */
    /* MARK: Init                                           */
    /* ==================================================== */
    private override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    public required init?(name: String, shortDesc: String, longDesc: String, url: String, duration: Double, released: Bool, status: Int) {
        
        let _moc = DKSessionDataHandler.default.managedObjectContext
        
        guard let _session = NSEntityDescription.entity(forEntityName: NSStringFromClass(DKPriveSession.self), in: _moc) else {return nil}
        
        super.init(entity: _session, insertInto: _moc)
        
        self.name = name
        self.status = Int16(status)
        self.duration = duration
        self.isReleased = released
        self.expressionShort = shortDesc
        self.expressionLong = longDesc
        self.url = url
        self.isFavorite = false
        self.isPremium = false
        self.hasNewMember = false
        
        guard let _locSv = DKSubversion(name: name) else {return nil}
        _locSv.isPremium = false
        _locSv.isFixed = false
        _locSv.source = url
        _locSv.durationRemote = duration
        
        
        if #available(iOS 10, *) {
            addToSubVersion(_locSv)
        } else {
            addToSubVersionLegacy(_locSv)
        }
    }
    
    
    
    public convenience init() {
        self.init(name: "", shortDesc: "", longDesc: "", url: "", duration: 0, released: false, status: 0)!
    }
    
    
    
    /* ==================================================== */
    /* MARK: Methods                                        */
    /* ==================================================== */
    
    // -----------------------------------
    // Public methods
    // -----------------------------------
    ///
    /// Checks the new source, if it's changed,
    /// first deletes the existing downloaded file
    /// and the accepts the new source
    ///
    public func updateSource(with url: String) {
        guard let _sv = self.sv?.first else {return}
        _sv.updateSource(with: url)
    }
    // -----------------------------------
    
    
    // -----------------------------------
    // Private methods
    // -----------------------------------
    
    // -----------------------------------
    
    
}
