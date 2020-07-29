//
//  DKSessionTheme+CoreDataClass.swift
//  SessionKit
//
//  Created by Ferhat Abdullahoglu on 15.12.2018.
//  Copyright © 2018 Ferhat Abdullahoglu. All rights reserved.
//
//

import Foundation
import CoreData
import AVFoundation

@objc(DKSessionTheme)
open class DKSessionTheme: DKSession {
    
    private override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    public required init? (name: String, expression: String, id: Int, imageName: String?, displayName: String?=nil) {
        
        let _moc = DKSessionDataHandler.default.managedObjectContext
        
        guard let _session = NSEntityDescription.entity(forEntityName: NSStringFromClass(DKSessionTheme.self), in: _moc) else {return nil}
        
        super.init(entity: _session, insertInto: _moc)
        
        if let dName = displayName {
            self.displayName = dName
        } else {
            self.displayName = name
        }
        
        self.name = name 
        self.isFavorite = false
        self.isPremium = false 
        self.imageName = imageName
        self.id = Double(id)
        
        guard let locSv = DKSubversion(name: name) else {return nil}
        locSv.isPremium = isPremium
        locSv.isFixed = true
        locSv.isCompleted = false
        locSv.id = 0
        locSv.source = ""
        
        if #available(iOS 10, *) {
            addToSubVersion(locSv)
        } else {
            addToSubVersionLegacy(locSv)
        }
        
    }
    
    public convenience init() {
        self.init(name: "", expression: "", id: 0, imageName: "")!
    }
    
    
    deinit {
        print("DeInit: SessionTheme")
        if audioSession != nil {
            audioSession?.stop()
            audioSession = nil
        }
    }
    
    
    open var image: UIImage? {
        guard let name = imageName else {return nil}
        return UIImage(named: name)
    }
    
    public var isPlaying: Bool {
        guard let session = audioSession else {return false}
        print("\(self.name) is playing: \(session.isPlaying)")
        return session.isPlaying
    }
    
    public var volume: Float = 0 {
        didSet {
            guard let _session = audioSession else { return }
            if #available(iOS 10.0, *) {
                _session.setVolume(volume / 100.0, fadeDuration: 0.4)
            } else {
                _session.volume = volume / 100.0
            }
        }
    }
    

    internal var audioSession: AVAudioPlayer?
    internal var stopped = false
}
