//
//  SessionPlayable.swift
//  SessionKit
//
//  Created by Ferhat Abdullahoglu on 21.11.2018.
//  Copyright © 2018 Ferhat Abdullahoglu. All rights reserved.
//

import Foundation
import AVFoundation

public protocol SessionPlayable: AVAudioPlayerDelegate {
    
    /* ==================================================== */
    // MARK: Properties
    /* ==================================================== */
    
    /**
     Session object to be played
     */
    var session: DKSession! { get set }
    
    /**
    Selected index within the session
     */
    var svIdx: Int { get set }
    
    /**
     Audio player
     */
    var audioPlayer: AVAudioPlayer! { get set }
    
  
    /**
     Audio player initialized flag
     */
    var playerInitialized: Bool { get set }
}

/* ==================================================== */
// MARK: Default SessionPlayable implementation
/* ==================================================== */
public extension SessionPlayable {
    
    /**
     Method to check if the session needs to be downloaded first
     - returns: __True__ if the session can be played right away
     */
    func isSessionDownloaded() -> Bool {
        return false
    }
    
    /**
     Method that sets up AV Session
     - returns: __True__ in case the operation is successful
                __False__ if otherwise
     */
    func createAudioSession(from _sv: DKSubversion) -> Bool {
        
        let _path = _sv.Url
        
        guard !_path.isEmpty else {return false}
        
        let _url = URL(fileURLWithPath: _path)

        //
        // Prepare the audioSession
        //
        do {
            //
            // Try to create the audioPlayer
            //
            audioPlayer = try AVAudioPlayer(contentsOf: _url)
            audioPlayer.delegate = self
            
            if #available(iOS 10.0, *) {
                try AVAudioSession.sharedInstance().setCategory(.playback,
                                                                mode: .default)
            }
            //
            try AVAudioSession.sharedInstance().setActive(true)
            
            //
            // Successfully created the player
            // and activated the audioSession
            //
            playerInitialized = true 
            return audioPlayer.prepareToPlay()
            
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    
    /**
     Method to play/pause the player
     
     Adopters of this protocol are free to implement their own way of play pause controls
     */
    func playPause() {
        if playerInitialized {
            if audioPlayer.isPlaying {
                audioPlayer.pause()
            } else {
                audioPlayer.play()
            }
        }
    }
}
