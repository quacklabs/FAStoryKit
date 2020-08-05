//
//  DKSession.swift
//  SessionKit
//
//  Created by Ferhat Abdullahoglu on 26.11.2018.
//  Copyright © 2018 Ferhat Abdullahoglu. All rights reserved.
//

import Foundation
import CoreData

public protocol DKSessionDelegate {
    func sessionDidAddSubversion(_ sv: DKSubversion)
    func checkNew(sender: DKSession) // Function must be used by the delegee (probably a category object) to check if there are any updated Sessions remain within them
}

public extension DKSession {
    
    // ==================================================== //
    // MARK: IBOutlets
    // ==================================================== //
    
    
    // ==================================================== //
    // MARK: IBActions
    // ==================================================== //
    
    
    // ==================================================== //
    // MARK: Properties
    // ==================================================== //
    
    // -----------------------------------
    // Public properties
    // -----------------------------------
    
    /// Number of the subversions within the session
    var numOfVersions: Int {
        guard let _sv = sv else {return 0}
        return _sv.count
    }
    
    /// An array of the subversions if there are any
    var sv: [DKSubversion]? {
        guard let _sv = subVersion else {return nil}
        guard var __sv = _sv.array as? [DKSubversion] else {return nil}
        __sv.sort(by: {return $0.duration < $1.duration})
        return __sv
    }
    
    /**
     User completed all the subversion in this session
     */
    var isCompleted: Bool {
        var completed = true
        
        guard let _sv = sv else {return false}
        
        for __sv in _sv {
            if !__sv.isCompleted {
                completed = false
                break
            }
        }
        
        return completed
    }
    
    /**
     User has completed at least one subversion
     */
    var hasOneCompleted: Bool {
        var completed = false
        
        guard let _sv = sv else {return false}
        
        for __sv in _sv {
            if !__sv.isCompleted {
                completed = false
                break
            }
        }
        
        return completed
    }
    
    /**
     Has at least one version that's fixed
     */
    var hasOneFixedSv: Bool {
        guard let _sv = sv else {return false}
        for __sv in _sv {
            if __sv.isFixed {
                return true
            }
        }
        return false 
    }
    // -----------------------------------
    
    
    // -----------------------------------
    // Private properties
    // -----------------------------------
    
    // -----------------------------------
    
    
    // ==================================================== //
    // MARK: Methods
    // ==================================================== //
    
    // -----------------------------------
    // Public methods
    // -----------------------------------
    // Append a new subversion -> will be used only when a new version of a session is downloaded
    func appendSubVersion(inSv: DKSubversion) {
        
    }
    
    
    /**
     Method to update the subversions within the session
     - parameters:
        - _sv: __[DKSubversion]__ - Subversions to check
     - returns:
     */
    func updateSubversions(with _sv: [SubVersionDbModel], completion: ((Bool)->Void)?=nil) {
        var __sv = _sv
        
        //
        // Check the subversions which must be deleted
        //
        if let _needsDelete = checkNeedsDelete(_sv) {
            if #available(iOS 10, *) {
               self.removeFromSubVersion(NSOrderedSet(array: _needsDelete))
            } else {
                for sv in _needsDelete {
                    self.removeFromSubVersionLegacy(sv)
                }
            }
            
            _needsDelete.forEach { (_deleted) in
                if let _idx = __sv.firstIndex(where: {return $0.name == _deleted.name}) {
                    __sv.remove(at: _idx)
                }
            }
        }
        
        //
        // Check the subversions which must be added
        //
        if let _needsAdd = checkNeedsAdd(_sv) {
            _needsAdd.forEach { (_svModel) in
                if let _sv = DKSubversion(data: _svModel) {
                    
                    if #available(iOS 10, *) {
                        self.addToSubVersion(_sv)
                    } else {
                        self.addToSubVersionLegacy(_sv)
                    }
                    
                    
                    self.hasNewMember = DKSessionDataHandler.default.dbUpdateDoneOnce
                    if let _idx = __sv.firstIndex(where: {_svModel == $0}) {
                        __sv.remove(at: _idx)
                    }
                }
            }
        }
        
        
        ///
        /// Remaining ones are the ones to be checked for updates
        ///
        for _version in __sv {
            guard let _existing = sv?.first(where: {return Int($0.id) == _version.id}) else {continue}
            
            _existing.durationRemote = _version.duration
            _existing.updateSource(with: _version.source)
        }
        
        completion?(true)
        
    }
    
    /**
     Method to remove all the existing subversions of a session
     in order to prepare it for deletion
     
     This method will automatically delete any downloaded files related with its
     subversion. If it's required that the file stays in place and not be deleted then
     the __abstract__ parameter must be set to true. This could happen if a __DKSession__ object
     is generated directly from a database model in order for updating the local model. In that
     case the app checks if the session is unique and if not it deletes the newly generated session object.
     By that it would delete the existing files too as it the source & url would match. That's why there
     is the __abstract__ parameter exists, so that such undesired behaviour could be avoided.
     
     - parameters:
        - abstract: Set to true if the session that's being deleted is an auixilary element
     */
    func removeAllSv(abstract: Bool = false) {
        guard let _sv = sv else {return}
        _sv.forEach({
            //
            // Try to delete the related file if it's already downloaded
            //
            if !$0.isFixed && !abstract {
                if !$0.Url.isEmpty {
                    if FileHandler.shared.fileExists(at: $0.Url) {
                        try? FileManager.default.removeItem(at: URL(fileURLWithPath: $0.Url))
                    }
                }
            }
            if #available(iOS 10, *) {
                self.removeFromSubVersion($0)
            } else {
                self.removeFromSubVersionLegacy($0)
            }
            DKSessionDataHandler.default.managedObjectContext.delete($0)
        })
    }
    // -----------------------------------
    
    
    // -----------------------------------
    // Private methods
    // -----------------------------------

    /**
     Checks the incoming sv, it updates the existing sv if it's found. If it's not found it does nothing
     - parameters:
     - :
     - returns:
     */
    private func checkNeedsDelete(_ new: [SubVersionDbModel]) -> [DKSubversion]? {
        // fetch the subversions
        guard let _sv = self.sv else {return nil}
        
        var _needsDelete = [DKSubversion]()
        
        for __sv in _sv.filter({return !$0.isFixed}) {
            if !new.filter({return $0.name == __sv.name}).isEmpty {
                continue
            } else {
                _needsDelete.append(__sv)
            }
        }
        
        return _needsDelete.isEmpty ? nil : _needsDelete
    }
    
    
    /**
     Chechks the incoming sv to figure out which ones are to be created
     - parameters:
     - :
     - returns:
     */
    private func checkNeedsAdd(_ new: [SubVersionDbModel]) -> [SubVersionDbModel]? {
        // fetch the subversions
        guard let _sv = self.sv else {return nil}
        
        var _needsAdd = [SubVersionDbModel]()
        
        for _new in new {
            if _sv.filter({return $0.name == _new.name}).isEmpty {
                _needsAdd.append(_new)
            }
        }
        
        return _needsAdd.isEmpty ? nil : _needsAdd
    }
    // -----------------------------------
    
} // end of the Session class definition


public extension DKSession {
    override open var description: String {
        return """
        Name: \(self.name)
        Premium: \(String(describing: self.isPremium))
        Expression: \(expressionShort ?? "no expression")
        \(subVersion?.count ?? 0) subversions named:
        \(subVersion?.compactMap { (_sv) -> String? in
        guard let _sv = _sv as? DKSubversion else {return nil}
        return _sv.name
        } ?? [])
        """
    }
}

public extension NSSortDescriptor {
    ///
    /// Sort description that would sort the __DKCategory__ objects
    /// with increasing __id__
    ///
    static var dkSessionIncreasingId: NSSortDescriptor {
        return NSSortDescriptor(key: "id", ascending: true)
    }
}
