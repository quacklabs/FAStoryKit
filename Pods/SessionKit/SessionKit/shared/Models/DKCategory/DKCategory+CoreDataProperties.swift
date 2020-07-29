//
//  DKCategory+CoreDataProperties.swift
//  SessionKit
//
//  Created by Ferhat Abdullahoglu on 1.12.2018.
//  Copyright © 2018 Ferhat Abdullahoglu. All rights reserved.
//
//

import Foundation
import CoreData


extension DKCategory {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DKCategory> {
        return NSFetchRequest<DKCategory>(entityName: "DKCategory")
    }
    
    @NSManaged public var id: Int16
    @NSManaged public var categoryExpression: String?
    @NSManaged public var categoryName: String?
    @NSManaged public var hasNewMember: Bool
    @NSManaged public var sessions: NSOrderedSet?
    @NSManaged public var imageData: Data?
    @NSManaged public var rawImageData: Data?
    @NSManaged public var wasUsedLatest: Bool
    @NSManaged public var imageAverageColor: NSObject?
    @NSManaged public var isSpecial: Bool
    
}

// MARK: Generated accessors for sessions
extension DKCategory {
    
    @objc(insertObject:inSessionsAtIndex:)
    @NSManaged public func insertIntoSessions(_ value: DKSession, at idx: Int)
    
    @objc(removeObjectFromSessionsAtIndex:)
    @NSManaged public func removeFromSessions(at idx: Int)
    
    @objc(insertSessions:atIndexes:)
    @NSManaged public func insertIntoSessions(_ values: [DKSession], at indexes: NSIndexSet)
    
    @objc(removeSessionsAtIndexes:)
    @NSManaged public func removeFromSessions(at indexes: NSIndexSet)
    
    @objc(replaceObjectInSessionsAtIndex:withObject:)
    @NSManaged public func replaceSessions(at idx: Int, with value: DKSession)
    
    @objc(replaceSessionsAtIndexes:withSessions:)
    @NSManaged public func replaceSessions(at indexes: NSIndexSet, with values: [DKSession])
    
    @objc(addSessionsObject:)
    @NSManaged public func addToSessions(_ value: DKSession)
    
    @objc(removeSessionsObject:)
    @NSManaged public func removeFromSessions(_ value: DKSession)
    
    @objc(addSessions:)
    @NSManaged public func addToSessions(_ values: NSOrderedSet)
    
    @objc(removeSessions:)
    @NSManaged public func removeFromSessions(_ values: NSOrderedSet)
    
    public func addToSessionsLegacy(_ value: DKSession) {
        guard let _sessions = self.sessions else {return}
        willChangeValue(forKey: "sessions")
        let tempSet = NSMutableOrderedSet(orderedSet: _sessions)
        tempSet.add(value)
        self.sessions = tempSet
        didChangeValue(forKey: "sessions")
    }
    
    public func removeFromSessionsLegacy(_ value: DKSession) {
        guard let _sessions = self.sessions else {return}
        willChangeValue(forKey: "sessions")
        let tempSet = NSMutableOrderedSet(orderedSet: _sessions)
        tempSet.remove(value)
        self.sessions = tempSet
        didChangeValue(forKey: "sessions")
    }
}
