//
//  DKSessionTheme.swift
//  SessionKit
//
//  Created by Ferhat Abdullahoglu on 1.12.2018.
//  Copyright © 2018 Ferhat Abdullahoglu. All rights reserved.
//

import Foundation
import AVFoundation
import CoreData

public extension DKSessionTheme {
    /* ==================================================== */
    /* MARK: properties                                     */
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
    /* MARK: Overrides                                      */
    /* ==================================================== */
 
    
    /* ==================================================== */
    /* MARK: Methods                                        */
    /* ==================================================== */
    
    // -----------------------------------
    // Public methods
    // -----------------------------------
    /**
     Object will prepare itself for playing
     - returns: True if setup is successful
     */
    func setup(volume: Float) -> Bool {
        guard let _url = sv?.first?.Url else {return false}
        do {
            let player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: _url))
            player.prepareToPlay()
            player.numberOfLoops = -1 // should be played within a loop
            player.volume = volume / 100.0
            audioSession = player
            return true
        } catch {
            print("Can't get audio")
            return false
        }
    } // end of the setup() method
    
    
    /**
     Method that will start playing the background theme
     */
    func playPause() {
        guard let session = audioSession else {return}
        if !session.isPlaying {
            if stopped {
                stopped = false
                session.prepareToPlay()
            }
            session.play()
        } else {
            session.pause()
        }
    } // end of the play() method
    
    /**
     Method to start playing
     */
    func play() {
        guard let _session = audioSession else { return }
        _session.play()
    }
    
    /**
     Method to stop and/or invalidate the active session
     */
    func stop() {
        guard let session = audioSession else {return}
        session.stop()
        stopped = true
    } // end of the stop() method
    // -----------------------------------
    
    
    // -----------------------------------
    // Private methods
    // -----------------------------------
    
    // -----------------------------------
}
