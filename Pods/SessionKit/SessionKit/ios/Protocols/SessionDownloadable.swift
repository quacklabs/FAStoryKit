//
//  SessionDownloadable.swift
//  SessionKit
//
//  Created by Ferhat Abdullahoglu on 19.11.2018.
//  Copyright © 2018 Ferhat Abdullahoglu. All rights reserved.
//

import Foundation 

/// Main behaviour implementation for __Session__ download handling
public protocol SessionDownloadable: DownloadServiceDelegate {
    /**
     Download service handler
     */
    var downloadService: DownloadService! { get set }
    
    /**
     Download progress 0...100%
     */
    var downloadProgress: Float { get set }
}

public extension SessionDownloadable {
    
    
    //
    // MARK: SessionDownloadable protocol default implementations
    //
    
    /**
     Method to initiate a download
     - parameters:
        - url: URL to download from
        - name: Name that will be used for saving downloaded file
        - destination: Destination to save the downloaded file
     */
    func startDownload(url: URL, name: String, destination: FileDestination_enm) {
        
        //
        // Initialize the service
        //
        guard let _service = DownloadService(url: url,
                                             username: nil,
                                             password: nil,
                                             destPath: destination,
                                             filename: name,
                                             fileType: "mp3") else {return}
        
        downloadService = _service
        
        downloadService.delegate = self
        
        downloadService.start()
    }
    
    
    //
    // MARK: DownloadServiceDelegate methods
    //
    func dlComplete(toPath: String) {
        print("dl completed: \(toPath)")
        downloadService = nil
    }
    
    func dlProgress(_ progress: Float) {
        DispatchQueue.main.async { [weak self] in
            self?.downloadProgress = progress
        }
    }
    
    func dlError(err: Error?, errType: DonwloadServiceErrors_enm) {
        print(err?.localizedDescription ?? "no error text")
        downloadService = nil
    }
    
}
