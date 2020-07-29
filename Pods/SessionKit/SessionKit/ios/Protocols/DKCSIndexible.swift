//
//  DKIndexContent.swift
//  SessionKit
//
//  Created by Ferhat Abdullahoglu on 28.12.2018.
//  Copyright © 2018 Ferhat Abdullahoglu. All rights reserved.
//

import Foundation
import CoreSpotlight
import MobileCoreServices

internal enum DKCSConentType: Int {
    case category = 0
    case session = 1
}


internal protocol DKCSIndexible: class {
    func indexingCompleted()
    func indexingFailed(error: Error)
}

internal extension DKCSIndexible {
    /**
     Method to index content in CoreSpotligh
     - parameters:
     - :
     - returns:
     */
    func indexContent<T>(_ content: T, type: DKCSConentType) {
        //
        // switch over the content type
        //
        switch type {
        case .session:
            if let _session = content as? [DKSession] {
                indexSession(_session)
            } else if let _session = content as? DKSession {
                indexSession([_session])
            }
            return
        case .category:
            if let _category = content as? [DKCategory] {
                indexCategory(_category)
            } else if let _category = content as? DKCategory {
                indexCategory([_category])
            }
            return
        }
    }
    
    private func indexCategory(_ category: [DKCategory]) {
        
    }
    
    private func indexSession(_ session: [DKSession]) {
        var _items = [CSSearchableItem]()
        
        for _session in session {
            let searchItemAttributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeMP3 as String)
            searchItemAttributeSet.artist = "Crea"
            searchItemAttributeSet.album = _session.parent?.categoryName?.getLocalized() ?? "Crea"
            searchItemAttributeSet.displayName = _session.name
            searchItemAttributeSet.title = _session.name
            searchItemAttributeSet.subject = _session.expressionShort
            searchItemAttributeSet.theme = _session.expressionLong
            if let _sv = _session.sv?.first {
                let _url = _sv.Url
                if !_url.isEmpty {
                    searchItemAttributeSet.contentURL = URL(fileURLWithPath: _url)
                }
            }
            
            //
            let item = CSSearchableItem(uniqueIdentifier: _session.name, domainIdentifier: "DKSession", attributeSet: searchItemAttributeSet)
            
            _items.append(item)
            
        }
        
        CSSearchableIndex.default().deleteSearchableItems(withDomainIdentifiers: ["DKSession"]) { (error) in
            guard error == nil else {
                self.indexingFailed(error: error!)
                return
            }
            
            CSSearchableIndex.default().indexSearchableItems(_items,
                                                             completionHandler: { (error) in
                                                                guard error == nil else {
                                                                    self.indexingFailed(error: error!)
                                                                    return
                                                                }
                                                                self.indexingCompleted()
            })
        }
    }
    
}
