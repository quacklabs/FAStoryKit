//
//  FileSingleton.swift
//  Mf_3
//
//  Created by Ferhat Abdullahoglu on 23.12.2016.
//  Copyright © 2016 Ferhat Abdullahoglu. All rights reserved.
//

import Foundation

// Source & Destination types
public enum FileDestination_enm {
    case toLibraries
    case toAppSupport
    case toSessions
    case toObjectMap
    case toCategoryAssets
    case toCache
}

// Helper class for the file handling parameterizations
public class FileHandler: NSObject {
    public var linkToLibrariesFolder: URL!
    public var linkToAppSupportFolder: URL!
    public var linkToSessionsFolder: URL!
    public var linkToObjectMapFolder: URL!
    public var linkToPreferencesFolder: URL!
    public var linkToArticlesFolder: URL!
    public var linkToPriveFolder: URL!
    public var linkToWatchDataFolder: URL!
    public var linkToSessionsShared: URL!
    public var fileSystemSetupProperly: Bool = false
    public let sessionFolderName: String = "Sessions"
    public let linkToCategoryAssetFolder: URL!
    public let linkToCache: URL!
    private let setup = FileSystemInit()
    
    // Create a member to return a static object of this class
    public static let shared = FileHandler()
    
    public var manager = FileManager.default
    
    public func fileExists(at url: String) -> Bool {
        return FileManager.default.fileExists(atPath: url)
    }
    
    override init() {
        linkToAppSupportFolder = setup.appSupport
        linkToSessionsFolder = setup.sessionFolder
        linkToObjectMapFolder = setup.objectMap
        linkToPreferencesFolder = setup.preferencesFolder
        linkToArticlesFolder = setup.articlesDataFolder
        linkToPriveFolder = setup.priveOrdersFolder
        linkToWatchDataFolder = setup.watchDataFolder
        linkToSessionsShared = setup.sharedSessionsFolder
        linkToCategoryAssetFolder = setup.categoryAssetFolder
        linkToCache = setup.cachesFolder
        fileSystemSetupProperly = true
        
        super.init() 
    }
    
    
    public func getAssetFolder(for category: String) -> URL? {
        let _isCreated = setup.createAssetFolder(for: category)
        if _isCreated {
            return linkToCategoryAssetFolder.appendingPathComponent(category)
        } else {
            return nil
        }
    }
}
