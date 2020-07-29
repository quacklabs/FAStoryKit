//
//  DKSession+CoreDataProperties.swift
//  SessionKit
//
//  Created by Ferhat Abdullahoglu on 1.12.2018.
//  Copyright © 2018 Ferhat Abdullahoglu. All rights reserved.
//
//

import Foundation
import CoreData


extension DKSession {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DKSession> {
        return NSFetchRequest<DKSession>(entityName: "DKSession")
    }
    
    /// Session has a subversion the user has not checked yet
    @NSManaged public var hasNewMember: Bool
    @NSManaged public var expressionLong: String?
    @NSManaged public var expressionShort: String?
    @NSManaged public var id: Double
    @NSManaged public var isFavorite: Bool
    @NSManaged public var isPremium: Bool
    @NSManaged public var name: String
    @NSManaged public var parent: DKCategory?
    @NSManaged public var subVersion: NSOrderedSet?
    @NSManaged public var dispName: String?
    
}

// MARK: Generated accessors for subVersion
extension DKSession {
    
    @objc(insertObject:inSubVersionAtIndex:)
    @NSManaged public func insertIntoSubVersion(_ value: DKSubversion, at idx: Int)
    
    @objc(removeObjectFromSubVersionAtIndex:)
    @NSManaged public func removeFromSubVersion(at idx: Int)
    
    @objc(insertSubVersion:atIndexes:)
    @NSManaged public func insertIntoSubVersion(_ values: [DKSubversion], at indexes: NSIndexSet)
    
    @objc(removeSubVersionAtIndexes:)
    @NSManaged public func removeFromSubVersion(at indexes: NSIndexSet)
    
    @objc(replaceObjectInSubVersionAtIndex:withObject:)
    @NSManaged public func replaceSubVersion(at idx: Int, with value: DKSubversion)
    
    @objc(replaceSubVersionAtIndexes:withSubVersion:)
    @NSManaged public func replaceSubVersion(at indexes: NSIndexSet, with values: [DKSubversion])
    
    @objc(addSubVersionObject:)
    @NSManaged public func addToSubVersion(_ value: DKSubversion)
    
    @objc(removeSubVersionObject:)
    @NSManaged public func removeFromSubVersion(_ value: DKSubversion)
    
    @objc(addSubVersion:)
    @NSManaged public func addToSubVersion(_ values: NSOrderedSet)
    
    @objc(removeSubVersion:)
    @NSManaged public func removeFromSubVersion(_ values: NSOrderedSet)
    
    public func addToSubVersionLegacy(_ value: DKSubversion) {
        guard let _sv = self.subVersion else {return}
        willChangeValue(forKey: "subVersion")
        let tempSet = NSMutableOrderedSet(orderedSet: _sv)
        tempSet.add(value)
        self.subVersion = tempSet
        didChangeValue(forKey: "subVersion")
    }
    
    public func removeFromSubVersionLegacy(_ value: DKSubversion) {
        guard let _sv = self.subVersion else {return}
        willChangeValue(forKey: "subVersion")
        let tempSet = NSMutableOrderedSet(orderedSet: _sv)
        tempSet.remove(value)
        self.subVersion = tempSet
        didChangeValue(forKey: "subVersion")
    }
    
}
