//
//  MedCategory.swift
//  Mf_3
//
//  Created by Ferhat Abdullahoglu on 12.12.2016.
//  Copyright © 2016 Ferhat Abdullahoglu. All rights reserved.
//

import UIKit

public extension DKCategory  {
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
    ///
    /// Count of the sessions within the category
    ///
    var sessionCount: Int {
        guard let _sessions = sessionArray else {return 0}
        return _sessions.count
    }
    
    /// Category DKSession array
    var sessionArray: [DKSession]? {
        guard var _sessions = self.sessions?.array as? [DKSession] else {return nil}
  
        _sessions.sort(by: {return $0.id < $1.id})
        
        return _sessions
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
    /**
     Method to
     - parameters:
     - :
     - returns:
     */
    func updateSessions(with _sessions: [SessionDbModel], completion: ((Bool)->Void)?=nil) {
        var _sessionModels = _sessions
        let __sessions = _sessions
        
        //
        // Check the subversions which must be deleted
        //
        if let _needsDelete = checkNeedsDelete(__sessions) {
            if #available(iOS 10, *) {
                self.removeFromSessions(NSOrderedSet(array: _needsDelete))
            } else {
                for delete in _needsDelete {
                    self.removeFromSessionsLegacy(delete)
                }
            }
            _needsDelete.forEach { (_deleted) in
                if let _idx = _sessionModels.firstIndex(where: {return $0.name == _deleted.name}) {
                    _sessionModels.remove(at: _idx)
                }
            }
        }
        
        //
        // Check the subversions which must be added
        //
        if let _needsAdd = checkNeedsAdd(__sessions) {
            _needsAdd.forEach { (_model) in
                if let _session = DKSession(data: _model) {
                    _session.updateSubversions(with: _model.sv)
                    _session.hasNewMember = DKSessionDataHandler.default.dbUpdateDoneOnce
                    
                    if #available(iOS 10, *) {
                        self.addToSessions(_session)
                    } else {
                        self.addToSessionsLegacy(_session)
                    }
                    
                    if let _idx = _sessionModels.firstIndex(where: {_model == $0}) {
                        _sessionModels.remove(at: _idx)
                    }
                }
            }
        }
        
        ///
        /// Remaining ones are the ones to be checked for updates
        ///
        for _model in _sessionModels {
            guard let _existing = sessionArray?.first(where: {return _model.id == $0.id}) else {continue}
            
            _existing.expressionLong = _model.expressionLong
            _existing.expressionShort = _model.expressionShort
            _existing.dispName = _model.displayName
            _existing.updateSubversions(with: _model.sv)
        }
    }
    // -----------------------------------
    
    
    // -----------------------------------
    // Private methods
    // -----------------------------------
    
    /**
     Checks the incoming session, it updates the existing sv if it's found. If it's not found it does nothing
     - parameters:
     - :
     - returns:
     */
    private func checkNeedsDelete(_ new: [SessionDbModel]) -> [DKSession]? {
        // fetch the sessions
        guard let _sessions = self.sessionArray else {return nil}
        
        var _needsDelete = [DKSession]()
        
        for _session in _sessions {
            if !new.filter({return $0.name == _session.name}).isEmpty {
                continue
            } else if !_session.hasOneFixedSv {
                _needsDelete.append(_session)
            }
        }
        
        return _needsDelete.isEmpty ? nil : _needsDelete
    }
    
    
    /**
     Chechks the incoming sessions to figure out which ones are to be created
     - parameters:
     - :
     - returns:
     */
    private func checkNeedsAdd(_ new: [SessionDbModel]) -> [SessionDbModel]? {
        // fetch the sessions
        guard let _sessions = self.sessionArray else {return nil}
        
        var _needsAdd = [SessionDbModel]()
        
        for _new in new {
            if _sessions.filter({return $0.name == _new.name}).isEmpty {
                _needsAdd.append(_new)
            }
        }
        
        return _needsAdd.isEmpty ? nil : _needsAdd
    }
    // -----------------------------------

    
    
    
} // end of the MedCategory class definition

public extension NSSortDescriptor {
    ///
    /// Sort description that would sort the __DKCategory__ objects
    /// with increasing __id__
    ///
    static var dkCategoryIncreasingId: NSSortDescriptor {
        return NSSortDescriptor(key: "id", ascending: true)
    }
}

