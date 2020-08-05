//
//  MediaPlayerControllable.swift
//  SessionKit
//
//  Created by Ferhat Abdullahoglu on 22.11.2018.
//  Copyright © 2018 Ferhat Abdullahoglu. All rights reserved.
//

import Foundation
import MediaPlayer

///
/// Necessary communication handling between the Media Player
/// and any conforming object
///
/// All necessary tasks are implemented by default.
/// It's possible to extend the features if necessary

@objc
public protocol MediaPlayerControllable: class {
    
    /**
     Player object for the session
     */
    var audioPlayer: AVAudioPlayer! { get set }
   
    /**
     Method that toggles between the playing and paused
     statuses of the session
     */
    func playPause() -> Void
    
    func mediaInfo(forPause: Bool) -> [String:AnyObject]
    
}

public extension MediaPlayerControllable {
    
    /**
     Method to add seekForward & seekBackward commands
    */
    func subscribeToSkipCommands() {
        
        MPRemoteCommandCenter.shared().skipForwardCommand.isEnabled = true
        MPRemoteCommandCenter.shared().skipForwardCommand.preferredIntervals = [15]
        MPRemoteCommandCenter.shared().skipForwardCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            guard self.audioPlayer != nil else {return .commandFailed}
            self.audioPlayer.currentTime = min(self.audioPlayer.duration, self.audioPlayer.currentTime + 15)
            return .success
        }
        
        MPRemoteCommandCenter.shared().skipBackwardCommand.isEnabled = true
        MPRemoteCommandCenter.shared().skipBackwardCommand.preferredIntervals = [15]
        MPRemoteCommandCenter.shared().skipBackwardCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            guard self.audioPlayer != nil else {return .commandFailed}
            self.audioPlayer.currentTime = max(0, self.audioPlayer.currentTime - 15)
            return .success
        }
    }
  
    
    /**
     Method to subscribe to the events from the media player
     */
    func subscribeToMPRemoteCommands() {
        //
        // dispatch to the main queue
        DispatchQueue.main.async {
            
            UIApplication.shared.beginReceivingRemoteControlEvents()
            
            MPRemoteCommandCenter.shared().togglePlayPauseCommand.addTarget {[weak self] (_event) -> MPRemoteCommandHandlerStatus in
                if let strongSelf = self {
                    return strongSelf.remoteCommandEventDelegator(_event)
                } else {
                    return .commandFailed
                }
            }
            MPRemoteCommandCenter.shared().playCommand.addTarget {[weak self]  (_event) -> MPRemoteCommandHandlerStatus in
                if let strongSelf = self {
                    return strongSelf.remoteCommandEventDelegator(_event)
                } else {
                    return .commandFailed
                }
            }
            MPRemoteCommandCenter.shared().pauseCommand.addTarget {[weak self]  (_event) -> MPRemoteCommandHandlerStatus in
                if let strongSelf = self {
                    return strongSelf.remoteCommandEventDelegator(_event)
                } else {
                    return .commandFailed
                }
            }
            MPRemoteCommandCenter.shared().stopCommand.addTarget {[weak self]  (_event) -> MPRemoteCommandHandlerStatus in
                if let strongSelf = self {
                    return strongSelf.remoteCommandEventDelegator(_event)
                } else {
                    return .commandFailed
                }
            }
            

        } // end of the dispatch
    }
    
    /**
     Method that unsubscribes from all events
     */
    func unsubscribeFromMPRemoteCommands() {
        DispatchQueue.main.async {
            MPRemoteCommandCenter.shared().togglePlayPauseCommand.removeTarget(nil)
            MPRemoteCommandCenter.shared().playCommand.removeTarget(nil)
            MPRemoteCommandCenter.shared().pauseCommand.removeTarget(nil)
            MPRemoteCommandCenter.shared().stopCommand.removeTarget(nil)
            MPRemoteCommandCenter.shared().skipForwardCommand.removeTarget(nil)
            MPRemoteCommandCenter.shared().skipBackwardCommand.removeTarget(nil)
            UIApplication.shared.endReceivingRemoteControlEvents()
        }
    }
    
    /**
     Method thats set the data for the media player
     */
    func setMeta(with: [String:AnyObject]) {
        MPNowPlayingInfoCenter.default().nowPlayingInfo = with
    }
    
    
    /**
     Method that delegates the incoming commands from the media player
     */
    func remoteCommandEventDelegator(_ event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        if event.command == MPRemoteCommandCenter.shared().playCommand ||
            event.command == MPRemoteCommandCenter.shared().pauseCommand ||
            event.command == MPRemoteCommandCenter.shared().togglePlayPauseCommand ||
            event.command == MPRemoteCommandCenter.shared().stopCommand {
            
            if Thread.isMainThread {
                if self.audioPlayer.isPlaying {
                    self.setMeta(with: self.mediaInfo(forPause: true))
                } else {
                    self.setMeta(with: self.mediaInfo(forPause: false))
                }
                
                self.playPause()
            } else {
                
                DispatchQueue.main.async {
                    if self.audioPlayer.isPlaying {
                        self.setMeta(with: self.mediaInfo(forPause: true))
                    } else {
                        self.setMeta(with: self.mediaInfo(forPause: false))
                    }
                    
                    self.playPause()
                }
            }
            return .success
        } else {
            event.command.isEnabled = false
            return .commandFailed
        }
    }
    
    
}
