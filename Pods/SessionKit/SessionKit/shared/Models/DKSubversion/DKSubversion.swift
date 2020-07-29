//
//  DKSubversion.swift
//  SessionKit
//
//  Created by Ferhat Abdullahoglu on 26.11.2018.
//  Copyright © 2018 Ferhat Abdullahoglu. All rights reserved.
//

import Foundation
import AVFoundation

public extension DKSubversion {
    private var fileManager: FileManager {
        return FileManager.default
    }
    
    var Url: String {       // Path to the sesion in the file system
        get {
            // Check if it belongs to a fixed version
            if self.isFixed {
                // Check if the downcast succeeds
                guard let tmpPath = Bundle.main.path(forResource: name, ofType: "mp3") else {
                    return ""
                }
                return tmpPath
            } else { // Not a fixed version
                let tmpPath = FileHandler.shared.linkToSessionsFolder.appendingPathComponent("\(name).mp3").path
                // Check if the file exists locally or not
                if fileManager.fileExists(atPath: tmpPath) {
                    return tmpPath
                } else if fileManager.fileExists(atPath: FileHandler.shared.linkToSessionsShared.appendingPathComponent("\(name).mp3").path) {
                    return FileHandler.shared.linkToSessionsShared.appendingPathComponent("\(name).mp3").path
                } else {
                    return ""
                }
            }
            
        } // end of the Get property
    } // end of the Url member definition
    
    
    var duration : TimeInterval {
        get {
            // Check if the filePath for Url has been retrieved
            if !self.Url.isEmpty {
                do {
                    let tmpAudio = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Url))
                    return tmpAudio.duration
                } catch {
                    return 0
                }
            } else {
                // -----------------------------------
                // Check if self is located in an online source
                // if yes try to get duration info online
                // -----------------------------------
                if !self.isFixed {
                    // Check if the DurationRemote information is available
                    return TimeInterval(durationRemote)
                    
                } else { // Sv is fixed and yet there is no url -> something is wrong
                    print("Can't get url for the fixed sv: \(name)")
                    return 0
                }
                // -----------------------------------
            } // end of the check for the Url
        }
        
    } // end of the Duration variable definition
    
    ///
    /// Checks the new source, if it's changed,
    /// first deletes the existing downloaded file
    /// and the accepts the new source
    ///
    internal func updateSource(with source: String) {
        
        // if the source is currently empty or equal to the
        // new one, just update and continue
        guard let _old = self.source, !_old.isEmpty, _old != source else {
            self.source = source
            return
        }
        
        // check if the old version was already downloaded
        // if yes, delete the old version and setup space for the new one
        if !Url.isEmpty {
            do {
                try fileManager.removeItem(at: URL(fileURLWithPath: self.Url))
                self.source = source
            } catch {
                //
                // internal fault, don't do anything just yet
                //
                print("can't delete the old downloaded subversion")
            }
        } else { // the version isn't yet downloaded - just update the version
            self.source = source
        }
    }
    
    /// Deletes the downloaded source file if it's not a fixed version
    /// and has already been downloaded
    /// - Returns: True if the operataion is successful
    @discardableResult
    func deleteSource() -> Bool {
        guard !self.isFixed, !self.Url.isEmpty else { return false }
        do {
            try fileManager.removeItem(at: URL(fileURLWithPath: self.Url))
            return true
        } catch {
            print("subversion wasn't able to be deleted with error: \(error.localizedDescription)")
            return false
        }
    }
    
}
