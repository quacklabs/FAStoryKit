//
//  SetupFileSystem.swift
//  Mf_3
//
//  Created by Ferhat Abdullahoglu on 23.12.2016.
//  Copyright © 2016 Ferhat Abdullahoglu. All rights reserved.
//

import Foundation

public class FileSystemInit: FileManager, FileManagerDelegate {
    
    var appSupport: URL!
    var objectMap: URL!
    var sessionFolder: URL!
    var watchDataFolder: URL!
    var articlesDataFolder: URL!
    var priveOrdersFolder: URL!
    var preferencesFolder: URL!
    var sharedGroup: URL!
    var sharedSessionsFolder: URL!
    var categoryAssetFolder: URL!
    var cachesFolder: URL!
    
    public override init() {
        super.init()
        appSupport = getLinkToAppSupport()
        objectMap = createObjMap()
        sessionFolder = createSessionsFolder()
        watchDataFolder = createWatchDataFolder()
        articlesDataFolder = createArticlesFolder()
        priveOrdersFolder = createPriveOrdersFolder()
        preferencesFolder = getLinkToPreferencesFolder()
        cachesFolder = getLinkToCache()
        sharedGroup = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.ferhatab.Mastermind.DinginKafa")
        sharedSessionsFolder = createSessionsInSharedAppGroup()
        categoryAssetFolder = createCategoryAssetsFolder()
    }
    
    // Method to get the link to the library/AppSupport folder
    // returns true if the link can be received
    // returns false if there is an error
    public func getLinkToAppSupport() -> URL? {
        let paths = urls(for: .applicationSupportDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    // Method that returns the path to .Caches directory
    public func getLinkToCache() -> URL? {
        let paths = urls(for: .cachesDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    
    // Method to create the Sessions folder - the method at first will check if it already exists
    public func createSessionsFolder () -> URL? {
        let tmpFileMan = FileManager.default
        var sTemp = appSupport
        sTemp?.appendPathComponent("Sessions")
        // Check if the folder exists
        if tmpFileMan.fileExists(atPath: (sTemp?.path)!) {
            return sTemp
        } else { // must be created
            do {
                try tmpFileMan.createDirectory(at: sTemp!, withIntermediateDirectories: true, attributes: nil)
                return sTemp
            } catch {
                print(error)
                return nil
            }
        }
    }
    
    public func createWatchDataFolder() -> URL? {
        let tmpFileMan = FileManager.default
        var sTemp = appSupport
        sTemp?.appendPathComponent("WatchData")
        // Check if the folder exists
        if tmpFileMan.fileExists(atPath: (sTemp?.path)!) {
            return sTemp
        } else { // must be created
            do {
                try tmpFileMan.createDirectory(at: sTemp!, withIntermediateDirectories: true, attributes: nil)
                return sTemp
            } catch {
                print(error)
                return nil
            }
        }
    }
    
    // Method to create the Articles folder - the method at first will check if it already exists
    public func createArticlesFolder () -> URL? {
        let tmpFileMan = FileManager.default
        var sTemp = appSupport
        sTemp?.appendPathComponent("Articles")
        // Check if the folder exists
        if tmpFileMan.fileExists(atPath: (sTemp?.path)!) {
            return sTemp
        } else { // must be created
            do {
                try tmpFileMan.createDirectory(at: sTemp!, withIntermediateDirectories: true, attributes: nil)
                return sTemp
            } catch {
                print(error)
                return nil
            }
        }
    }
   
    
    // Method to create the folder for Category assests
    public func createCategoryAssetsFolder() -> URL? {
        let _fm = FileManager.default
        
        var sTemp = appSupport
        
        sTemp?.appendPathComponent("CategoryAssets")
        
        // Check first if the folder exists
        if _fm.fileExists(atPath: (sTemp?.path)!) {
            return sTemp
        } else { // must be created
            do {
                try _fm.createDirectory(at: sTemp!, withIntermediateDirectories: true, attributes: nil)
                return sTemp
            } catch {
                print(error.localizedDescription)
                return nil
            }
        }
    }
    
    public func createAssetFolder(for category: String) -> Bool {
        let _fm = FileManager.default
        
        var sTemp = appSupport
        
        sTemp?.appendPathComponent("CategoryAssets")
        sTemp?.appendPathComponent(category)
        
        // Check first if the folder exists
        if _fm.fileExists(atPath: (sTemp?.path)!) {
            return true
        } else { // must be created
            do {
                try _fm.createDirectory(at: sTemp!, withIntermediateDirectories: true, attributes: nil)
                return true
            } catch {
                print(error.localizedDescription)
                return false
            }
        }
    }
    
    // Method to create the archived prive orders folder
    public func createPriveOrdersFolder() -> URL? {
        let _fm = FileManager.default
        
        var sTemp = appSupport
        
        sTemp?.appendPathComponent("PriveOrders")
        
        // Check first if the folder exists
        if _fm.fileExists(atPath: (sTemp?.path)!) {
            return sTemp
        } else { // must be created
            do {
                try _fm.createDirectory(at: sTemp!, withIntermediateDirectories: true, attributes: nil)
                return sTemp
            } catch {
                print(error.localizedDescription)
                return nil
            }
        }
    }
    
    public func getLinkToPreferencesFolder() -> URL? {
        let paths = urls(for: .preferencePanesDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    // Method to create the object map folder
    public func createObjMap() -> URL? {
        let tmpFileMan = FileManager.default
        var sTemp = appSupport
        sTemp?.appendPathComponent("ObjectMap")
        // Check if the folder exists
        if tmpFileMan.fileExists(atPath: (sTemp?.path)!) {
            return sTemp
        } else { // must be created
            do {
                try tmpFileMan.createDirectory(atPath: sTemp!.path, withIntermediateDirectories: true, attributes: nil)
                return sTemp
            } catch {
                print(error.localizedDescription)
                return nil
            }
        }
    }
    
    public func createSessionsInSharedAppGroup() -> URL? {
        guard let _url = sharedGroup else {return nil}
        
        let _dest = _url.appendingPathComponent("Sessions", isDirectory: true)
        

        // check if the folder already exists
        if FileManager.default.fileExists(atPath: _dest.path) {
            return _dest
        } else {
            do {
                try FileManager.default.createDirectory(atPath: _dest.path, withIntermediateDirectories: true, attributes: nil)
                return _dest
            } catch {
                print(error.localizedDescription)
                return nil
            }
        }
    }
}
