//
//  CoreDataHelper.swift
//  Mf_3
//
//  Created by Ferhat Abdullahoglu on 20.08.2018.
//  Copyright © 2018 Ferhat Abdullahoglu. All rights reserved.
//
#if os(watchOS)
    import WatchKit
#endif

import CoreData

public typealias DKSessionUpdateAdapter = [String:[SessionDbModel]]

public class DKSessionDataHandler: NSObject {

    /* ==================================================== */
    /* MARK: IBOutlets                                      */
    /* ==================================================== */
    
    
    /* ==================================================== */
    /* MARK: IBActions                                      */
    /* ==================================================== */
    
    
    /* ==================================================== */
    /* MARK: Properties                                     */
    /* ==================================================== */
    
    // -----------------------------------
    // Public properties
    // -----------------------------------
    public static var `default` = DKSessionDataHandler()
    
    public var managedObjectModel: NSManagedObjectModel
    
    public var persistenStoreCoordinator: NSPersistentStoreCoordinator
    
    public var managedObjectContext: NSManagedObjectContext
    
    public var isValid = false
    
    public var dbUpdateDoneOnce = false
    // -----------------------------------
    
    
    // -----------------------------------
    // Private / Internal properties
    // -----------------------------------
    internal class var bundleId: String { // TBA - must fix this issue with CocoaPods DSL version 1.8.0
//        return "org.cocoapods.SessionKit"
        return Bundle(for: DKSessionDataHandler.self).bundleIdentifier!
//        #if os(iOS)
//            return "com.ferhatab.SessionKit"
//        #else
//            return "com.ferhatab.SessionKitWatch"
//        #endif
    }
    
    // -----------------------------------
    
    
    /* ==================================================== */
    /* MARK: Init                                           */
    /* ==================================================== */
    public override init() {
        
        guard let _mom = DKSessionDataHandler.getMom(),
            let _psc = DKSessionDataHandler.getPsc(with: _mom),
            let _moc = DKSessionDataHandler.getMoc(with: _psc)
            else {
                fatalError("can't initialize the store")
        }
        
        managedObjectModel = _mom
        persistenStoreCoordinator = _psc
        managedObjectContext = _moc
        
        super.init()
        
        isValid = true
        dbUpdateDoneOnce = UserDefaults.standard.bool(forKey: "dkDbUpdateDoneOnce")
        
        indexSessions()
    }
    
    
    /* ==================================================== */
    /* MARK: Methods                                        */
    /* ==================================================== */
    
    // -----------------------------------
    // Public methods
    // -----------------------------------
    /**
     Method that creates a new object from its entity description, ready to be saved into context
     */
    public func insertManagedObject(with className: String) -> AnyObject {
        let object =  NSEntityDescription.insertNewObject(forEntityName: className, into: managedObjectContext)
        
        return object
    }
    
    /**
     Tries to delete an entity matching the description and returns the result
     */
    public func deleteManagedObject(entityName: String, predicate: NSPredicate?) -> Bool {
        let _deleteRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        _deleteRequest.returnsObjectsAsFaults = false
        _deleteRequest.predicate = predicate
        //
        do {
            let _objs = try managedObjectContext.fetch(_deleteRequest)
            for _obj in _objs as! [NSManagedObject] {
                managedObjectContext.delete(_obj)
            }
        } catch {
            print(error.localizedDescription)
            return false
        }
        
        // Save the context
        do {
            try managedObjectContext.save()
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    /**
     Method that tries and saves the current context and returns the result
     */
    public func saveManagedObjetContext() -> Bool {
        do {
            try managedObjectContext.save()
            return true
        } catch {
            print((error as NSError).userInfo)
            print(error.localizedDescription)
            return false
        }
    }
    
    /**
     Main method to get any entity
     */
    public func fetchEntities(for className: String, predicate: NSPredicate?, sortDescriptor: [NSSortDescriptor]?) -> NSArray? {
        
        guard let entityDescription = NSEntityDescription.entity(forEntityName: className, in: managedObjectContext) else {return nil}
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        fetchRequest.entity = entityDescription
        
        if predicate != nil {
            fetchRequest.predicate = predicate
        }
        
        if sortDescriptor != nil {
            fetchRequest.sortDescriptors = sortDescriptor!
        }
        
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let items = try managedObjectContext.fetch(fetchRequest)
            return items as NSArray
        } catch {
            print(error.localizedDescription)
            return nil
        }
        
    }
    
    /**
     Gateway to the DB adapter
     - parameters:
        - data: DKSessionUpdateAdapter
     - returns:
     
     The completion is called in the main queue.
     */
    public func dbUpdate(with _data: DKSessionUpdateAdapter, specialCategory isSpecial: Bool = false, completion: ((Bool)->Void)?=nil)  {

        //
        // Execute the request on a background thread
        //
        DispatchQueue.main.async {
            ///
            /// Currently existing categories
            ///
            let predicate = NSPredicate(format: "isSpecial = %d", isSpecial)
            guard var _categories = self.fetchEntities(for: NSStringFromClass(DKCategory.self), predicate: predicate, sortDescriptor: [NSSortDescriptor.dkCategoryIncreasingId]) as? [DKCategory] else {
                completion?(false)
                return
            }
            
            ///
            /// Current max ID
            ///
            var _maxId = self.getMaxId(_categories)
            
            //
            // check the categories to be deleted
            //
            let _category = _categories.filter({return !_data.keys.contains($0.categoryName!)})
            
            if !_category.isEmpty {
                _category.forEach({
                    $0.sessionArray?.forEach({ (_session) in
                        _session.removeAllSv()
                        DKSessionDataHandler.default.managedObjectContext.delete(_session)
                    })
                    
                    DKSessionDataHandler.default.managedObjectContext.delete($0)
                })
                // remove the deleted sessions from the local container
                _categories.removeAll(where: {return _category.contains($0)})
                // update the max ID
                _maxId = self.getMaxId(_categories)
            }
            
            
            //
            // Get the categories and update - if a category doesn't exist, create it
            //
            for name in _data.keys {
                if let _category = _categories.first(where: {return $0.categoryName == name}), let __data = _data[name] {
                    _category.updateSessions(with: __data)
                } else {
                    guard let _category = DKCategory(name: name, id: _maxId+1), let __data = _data[name] else {continue}
                    _category.isSpecial = isSpecial
                    _category.updateSessions(with: __data)
                    _categories.append(_category)
                    _maxId = self.getMaxId(_categories)
                }
            }
            
            let _result = self.saveManagedObjetContext()
            
            
            //
            // Throw back to the main thread
            //
            DispatchQueue.main.async {
                if _result && !isSpecial {
                    UserDefaults.standard.set(true, forKey: "dkDbUpdateDoneOnce")
                }
                completion?(_result || isSpecial)
            }
        } // end of background disaptch
        
    }
    
    /// Method to set the expression of a category
    ///
    /// - parameter expression: Expression to be set
    /// - parameter category: Name of the category to set the expression for
    ///
    /// - returns: True if the operation is successful, false if otherwise
    public func setExpression(_ expression: String, for category: String) -> Bool {
        //
        // get the category
        //
        let fetchRequest = NSFetchRequest<DKCategory>(entityName: "DKCategory")
        let fetchPredicate = NSPredicate(format: "categoryName = %@", category)
        fetchRequest.predicate = fetchPredicate
        
        do {
            guard let _category = try managedObjectContext.fetch(fetchRequest).first else {return false}
            _category.categoryExpression = expression
            return saveManagedObjetContext()
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    /// Method to set the category's wasUsedLatest bit
    ///
    /// Calling this function on a cateogry will reset the
    /// older category's wasUsedLatest bit
    ///
    /// - parameter category: Category object on which the latestUsed bit should be set
    /// - returns: True if the operation is successful False if otherwise
    
    public func setLastActive(for category: DKCategory) -> Bool {
        ///
        /// Currently existing categories
        ///
        guard let _categories = self.fetchEntities(for: NSStringFromClass(DKCategory.self), predicate: nil, sortDescriptor: [NSSortDescriptor.dkCategoryIncreasingId]) as? [DKCategory] else {return false}
        
        _categories.forEach({$0.wasUsedLatest = false})
        
        category.wasUsedLatest = true
        
        return saveManagedObjetContext()
    }
    // -----------------------------------
    
    
    // -----------------------------------
    // Private methods
    // -----------------------------------
    /**
     Gets the managed object model
     */
    private class func getMom() -> NSManagedObjectModel? {
        guard let proxyBundle = Bundle(identifier: DKSessionDataHandler.bundleId) else {return nil}
        
        guard let modelURL = proxyBundle.url(forResource: "SessionData", withExtension: "momd") else {return nil}
        
        return NSManagedObjectModel(contentsOf: modelURL)
    }
    
    /**
     Gets the persistentStoreCoordinator
     */
    private class func getPsc(with mom: NSManagedObjectModel) -> NSPersistentStoreCoordinator? {
        
        guard let contanierUrl = FileHandler.shared.linkToAppSupportFolder else {return nil}
        
        let storeURL = contanierUrl.appendingPathComponent("database.sqlite")
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: mom)
        
        do {
            let options = [NSMigratePersistentStoresAutomaticallyOption:true,
                           NSInferMappingModelAutomaticallyOption:true]
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: options
            )
        } catch  {
            print(error.localizedDescription)
            return nil
        }
        return coordinator
    }
    
    /**
     Gets the managedObjectContext
     */
    private class func getMoc(with psc: NSPersistentStoreCoordinator    ) -> NSManagedObjectContext? {
        let _managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        _managedObjectContext.persistentStoreCoordinator = psc
        
        _managedObjectContext.retainsRegisteredObjects = true
        
        return _managedObjectContext
    }
    
    /**
     Returns the maxID contained in a given set of categories
     - parameters:
     - :
     - returns:
     */
    private func getMaxId(_ categories: [DKCategory]) -> Int {
        var _id = 0
        
        categories.forEach({
            if Int($0.id) > _id {
                _id = Int($0.id)
            }
        })
        
        return _id
    }
    
    /**
     Creates a child context and assigns it to a parent
     */
    private class func getPrivateContext(parent: NSManagedObjectContext) -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = parent
        return context
    }
    
    /**
     Method to handle the indexing of all sessions
     */
    @available (iOS 9, *)
    private func indexSessions() {
        #if os(iOS)
            guard let _sessions = fetchEntities(for: NSStringFromClass(DKSession.self), predicate: nil, sortDescriptor: nil) as? [DKSession] else {return}
        
            indexContent(_sessions, type: .session)
        #endif
    }
    // -----------------------------------
}




