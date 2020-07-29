//
//  DownloadService.swift
//  Mf_3
//
//  Created by Ferhat Abdullahoglu on 4.01.2017.
//  Copyright © 2017 Ferhat Abdullahoglu. All rights reserved.
//

import Foundation

public enum DonwloadServiceErrors_enm {
    case sessionCantBeCreated
    case loginFailed
    case fileCantBeRemoved
    case fileCantBeCopied
    case urlSessionError
}

/* ==================================================== */
/* DownloadService protocols                            */
/* ==================================================== */
public protocol DownloadServiceDelegate: class {
    func dlError(err: Error?, errType: DonwloadServiceErrors_enm)   // Error occured during the download session
    func dlComplete(toPath: String)                                 // Download completed and the file has been moved to the "toPath"
    func dlProgress(_ progress: Float)
}


/* ==================================================== */
/* DlHandler_typ definition                             */
/* ==================================================== */
public struct DlHandler_typ {
    public var url: URL                        // Url to download from
    public var username: String?               // Username if log in is required
    public var password: String?               // Password in case a login is required
    public var destPath: FileDestination_enm?  // Destination path for the downloaded file - if this is empty than the downloaded file will not be moved
    public var destFileName: String?           // The name of the final file - if this is empty than the downloade file will not be copied
    public var fileType: String?               // Type of the final file
    public var middleFolder: String?
    public var sDestFolder: String? {          // Destination folder in String
        get {
            if let tmpDestPath = destPath {
                var tmpPath : String!
                // Case machine for different destinations
                switch tmpDestPath {
                    
                case .toAppSupport:
                    tmpPath = FileHandler.shared.linkToAppSupportFolder.path
                    
                case .toLibraries:
                    tmpPath = FileHandler.shared.linkToLibrariesFolder.path
                    
                case .toObjectMap:
                    tmpPath = FileHandler.shared.linkToObjectMapFolder.path
                    
                case .toSessions:
                    tmpPath = FileHandler.shared.linkToSessionsFolder.path
//                    tmpPath = FileHandler.shared.linkToSessionsShared.path
                    
                case .toCategoryAssets:
                    tmpPath = FileHandler.shared.linkToCategoryAssetFolder.path
                    
                case .toCache:
                    tmpPath = FileHandler.shared.linkToCache.path
                    
                } /* switch tmpDestPath */
                return tmpPath
            } else {
                return nil
            }
        }
    }
    
    public var destPathFinal: String? {        // Destination path in URL if the downloaded file needs to be copied to somewhere
        get {
            if let tmpDestPath = destPath, let tmpDestfileName = destFileName {
                if FileHandler.shared.fileSystemSetupProperly { // file system is properly setup
                    var toAppend : String!
                    var tmpPath : String?
                    if let tmpFileType = fileType {
                        toAppend = "\(tmpDestfileName).\(tmpFileType)"
                    } else {
                        toAppend = "\(tmpDestfileName)"
                    }
                    
                    // Case machine for different destinations
                    switch tmpDestPath {
                        
                    case .toAppSupport:
                        tmpPath = FileHandler.shared.linkToAppSupportFolder.appendingPathComponent(toAppend).path
                        
                    case .toLibraries:
                        tmpPath = FileHandler.shared.linkToLibrariesFolder.appendingPathComponent(toAppend).path
                        
                    case .toObjectMap:
                        tmpPath = FileHandler.shared.linkToObjectMapFolder.appendingPathComponent(toAppend).path
                        
                    case .toSessions:
                        tmpPath = FileHandler.shared.linkToSessionsFolder.appendingPathComponent(toAppend).path
                        
                    case .toCategoryAssets:
                        
                        if let _folder = middleFolder {
                            tmpPath = FileHandler.shared.linkToCategoryAssetFolder.appendingPathComponent(_folder).appendingPathComponent(toAppend).path
                        } else {
                            tmpPath = FileHandler.shared.linkToCategoryAssetFolder.appendingPathComponent(toAppend).path
                        }
                        
                    case .toCache:
                        tmpPath = FileHandler.shared.linkToCache.appendingPathComponent(toAppend).path
                    } /* switch tmpDestPath */
                    return tmpPath
                } else { // file system is not yet set up
                    return nil
                }
            } /* if destPath != nil && destFileName != nil */
            return nil
        } /* end of the get statement */
    } /* var destPathFinal */
    
    // MARKS: Struct initialization
    init?(url: URL, username: String?, password: String?, destPath: FileDestination_enm?, filename: String?, fileType: String?) {
        if url.absoluteString.isEmpty {
            return nil
        } else {
            self.url = url
            if username != nil {self.username = username}
            if password != nil {self.password = password}
            if destPath != nil {self.destPath = destPath}
            if filename != nil {self.destFileName = filename}
            if fileType != nil {self.fileType = fileType}
        }
    }
} // DlHandler_typ;


/* ==================================================== */
/* DownloadService class definitions                    */
/* ==================================================== */
public class DownloadService: NSObject {
    // MARKS: Members
    // Public members
    public var dlHAndler: DlHandler_typ?
    public var destPath: FileDestination_enm?
    public var username: String?
    public var password: String?
    public var url: URL
    public var fileName: String?
    public var fileType: String?
    public weak var delegate: DownloadServiceDelegate?
    @objc
    public var progress: Float {
        return bytesWritten/bytesExpected * 100
    }
    
    // Private members
    private var logInRequired: Bool?
    fileprivate var uUrl: URL!
    fileprivate var urlSession: URLSession!
    fileprivate var dlTask: URLSessionDownloadTask!
    private var shouldBeCopied: Bool?
    fileprivate var fileManager: FileManager!
    fileprivate var bytesExpected: Float = 0
    fileprivate var bytesWritten: Float = 0
    
    
    // MARKS: Initialization
    public init?(url: URL, username: String?, password: String?, destPath: FileDestination_enm?, filename: String?, fileType: String?, middleFolder: String?=nil) {
        if url.absoluteString.isEmpty {
            self.delegate?.dlError(err: nil, errType: .sessionCantBeCreated)
            print("Download Service: Url is empty")
            return nil
        } else {
            // Check the user credentials info -> both should be empty or both should has information
            if (username == nil && password == nil) {
                self.logInRequired = false
            } else if (username != nil && password != nil) {
                self.username = username
                self.password = password
                self.logInRequired = true
            } else {
                self.delegate?.dlError(err: nil, errType: .sessionCantBeCreated)
                print("Download Service: Invalid credentials - check the parameters")
                return nil
            }
            //
            self.url = url
            if destPath != nil {
                self.destPath = destPath
            }
            if filename != nil {self.fileName = filename}
            if fileName != nil {
                self.shouldBeCopied = true
            } else {
                self.shouldBeCopied = false
            }
            if let tmpFileType = fileType {
                self.fileType = tmpFileType
            }
            //
            guard let tmpHandler = DlHandler_typ(url: self.url, username: self.username, password: self.password, destPath: self.destPath, filename: self.fileName, fileType: self.fileType) else {return nil}
            self.dlHAndler = tmpHandler
            self.dlHAndler?.middleFolder = middleFolder
            super.init()
            self.urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
//            guard let tmpUrl = URL(string: self.url) else {return nil}
            self.dlTask = self.urlSession.downloadTask(with: self.url)
            self.fileManager = FileManager.default
        } /* if url.isempty */
    } // end of the initializer
    
    
    // MARKS: Methods
    // Start the download process
    public func start() {
        DispatchQueue.global(qos: .userInitiated).async {[weak self] in
            self?.dlTask.resume()
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
        }
        
    }
    
    // Copy the downloaded file to the local folder
    func moveToLocal(src: String) {
        // Unwrap optionals
        guard (self.dlHAndler?.sDestFolder) != nil else {return}
        guard let tmpPath = self.dlHAndler?.destPathFinal else {return}
        
        // Check first if the local copy already exists at the destination path
        if fileManager.fileExists(atPath: tmpPath) { // file exists -> needs to be removed
            do {
                try fileManager?.removeItem(atPath: tmpPath)
            } catch {
                print("File cannot be removed!")
                self.delegate?.dlError(err: error, errType: .fileCantBeRemoved)  // Notify the delegate
                self.urlSession.invalidateAndCancel()
                return
            }
        }
       
        // Move the file to local copy
        do {
            try fileManager.moveItem(atPath: src, toPath: tmpPath)
            self.delegate?.dlComplete(toPath: tmpPath)
        } catch {
            print(error.localizedDescription)
            self.delegate?.dlError(err: error, errType: .fileCantBeCopied)
            self.urlSession.invalidateAndCancel()
        }
    } /* moveToLocal() */
    
    deinit {
        self.urlSession.invalidateAndCancel()
        self.dlHAndler = nil
        self.fileManager = nil
        self.destPath = nil
        self.urlSession.invalidateAndCancel()
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        print("DeInit: DownloadService")
    }
    
} /* DownloadService */


/* ==================================================== */
/* Conforming to URLSession protocols                   */
/* ==================================================== */
extension DownloadService: URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate, URLSessionDownloadDelegate {
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        self.moveToLocal(src: location.path)
        self.urlSession.invalidateAndCancel()
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    public func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        if let err = error?.localizedDescription { // An error has occured
            print(err)
            self.delegate?.dlError(err: error, errType: .urlSessionError)
            self.urlSession.invalidateAndCancel()
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }       
    }
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        self.bytesWritten = Float(totalBytesWritten)
        bytesExpected = Float(totalBytesExpectedToWrite)
        delegate?.dlProgress(progress)
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error != nil { // An error has occurred
            print(error?.localizedDescription as Any)
            self.delegate?.dlError(err: error, errType: .urlSessionError)
            self.urlSession.invalidateAndCancel()
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
}


