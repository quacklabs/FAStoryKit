//
//  DKSession+CoreDataClass.swift
//  SessionKit
//
//  Created by Ferhat Abdullahoglu on 1.12.2018.
//  Copyright © 2018 Ferhat Abdullahoglu. All rights reserved.
//
//

import Foundation
import CoreData
import Intents

@objc(DKSession)
open class DKSession: NSManagedObject {
    
    
    /* ==================================================== */
    /* MARK: Properties                                     */
    /* ==================================================== */
    
    // -----------------------------------
    // Public properties
    // -----------------------------------
    /**
     Array of URls of the subsessions
     */
    open var urlList: [String] {
        var _list = [String]()
        
        guard let _sv = sv else {return []}
        
        _sv.forEach({
            if $0.Url.count > 0 {
                _list.append($0.Url)
            }
        })
        return _list
    }
    
    /// Name of the owner category
    open var categoryName: String? {
        return parent?.categoryName
    }
    
    // -----------------------------------
    
    
    // -----------------------------------
    // Private properties
    // -----------------------------------
    
    // -----------------------------------
    
    
    /* ==================================================== */
    /* MARK: Init                                           */
    /* ==================================================== */
    /**
     Initializes an abstract __DKSession__ object
     
     Keep in mind that hereby initialized objects are not saved to the
     context. The save operation must be carried out seperately
     
     - parameters:
         - name: Name of the new session
         - expressionShort: Short expression of the new session
         - expressionLong: Long epxression of the new session
     - returns:
     */
    public convenience init?(name: String, expressionShort: String?="", expressionLong: String?="", isPremium: Bool=false, with subversions: [DKSubversion]?=nil, id: Double, displayName: String?=nil) {
        
        let _moc = DKSessionDataHandler.default.managedObjectContext
        
        guard let _session = NSEntityDescription.entity(forEntityName: NSStringFromClass(DKSession.self), in: _moc) else {return nil}
        
        self.init(entity: _session, insertInto: _moc)
        
        self.name = name
        self.expressionLong = expressionLong
        self.expressionShort = expressionShort
        self.isFavorite = false
        self.isPremium = isPremium
        self.id = id
        self.hasNewMember = false
        self.dispName = displayName
    
        //
        // check for subversions
        //
        if let _sv = subversions {
            if #available(iOS 10, *) {
                let __sv = NSOrderedSet(array: _sv)
                self.addToSubVersion(__sv)
            } else {
                for __sv in _sv {
                    addToSubVersionLegacy(__sv)
                }
            }
        }
    }

    public convenience init() {
        self.init(name: "", expressionShort: "", expressionLong: "", id: 0)!
    }
    
    /**
     Initialize a __DKSession__ object through a __SessionDbModel__
     
     This intializer works as an adapter between the database model and a
     native CoreData object. This init is allowed to fail so be careful
     - parameters:
     - data: __SessionDbObject to initialize from
     - returns: __DKSession__?
     */
    public convenience init?(data: SessionDbModel) {
        //
        // get the subversions
        //
        var _subversions = [DKSubversion]()
        for _model in data.sv {
            guard let _sv = DKSubversion(data: _model) else {continue}
            _subversions.append(_sv)
        }
        
        //
        // Create the session object
        //
        self.init(name: data.name, expressionShort: data.expressionShort, expressionLong: data.expressionLong, isPremium: data.isPremium, with: _subversions, id: data.id, displayName: data.displayName)
    }
    
    
    
    /* ==================================================== */
    /* MARK: Methods                                        */
    /* ==================================================== */
    
    // -----------------------------------
    // Public methods
    // -----------------------------------
    /**
     Method that creates and returns a new DKSession object within context
     
     Call this function when you need a new abstract DKSession object
     
     - parameters:
     - name: Name of the new session
     - expressionShort: Short expression of the new session
     - expressionLong: Long epxression of the new sessoin
     - returns: __DKSession__ object if the init was successful
     */
    public class func create(name: String, expressionShort: String?, expressionLong: String?) -> DKSession? {
        let _mom = DKSessionDataHandler.default.managedObjectContext 
        
        guard let _session = NSEntityDescription.insertNewObject(forEntityName: NSStringFromClass(DKSession.self), into: _mom) as? DKSession else { return nil}
        
        _session.name = name
        _session.expressionShort = expressionShort
        _session.expressionLong = expressionLong
        
        return _session
    }
    
    /// Send out the Duration in string format
    open func setDurationString(idx: Int, abr: Bool) -> String {
        /* ------------------------------------------------ */
        /* Check for the duration to set the correct string */
        /* ------------------------------------------------ */
        guard let _sv = sv else {return "00:00"}
        
        guard idx < _sv.count else {return "00:00"}
        
        let tmpInt = Int(_sv[idx].duration / 60.0)
        if abr { // abbrevation is requested
            // Check where to round the value
            let tmpRem = Float(_sv[idx].duration).truncatingRemainder(dividingBy: 60.0)
            if tmpRem < 35 { // round down
                return ("\(tmpInt) \("min".getLocalized())")
            } else { // round up
                return ("\(tmpInt+1) \("min".getLocalized())")
            }
            
        } else {
            return ("\(tmpInt) - \(tmpInt+1) \("minutes".getLocalized())")
        }
    }
    
    /**
     Method that returns the source of a session on the server
     - parameters:
     - idx: Currently selected subversion of the session
     - returns: Path to the file on server
     */
    @objc
    open dynamic func getSourceFor(idx: Int) -> String? {
        guard let _sv = sv else {return nil}
        guard idx < _sv.count else {return nil}
        return _sv[idx].source
    }
    // -----------------------------------
    
    
    // -----------------------------------
    // Private methods
    // -----------------------------------
    
    // -----------------------------------
    
}


