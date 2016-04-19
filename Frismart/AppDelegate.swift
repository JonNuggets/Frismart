//
//  AppDelegate.swift
//  Frismart
//
//  Created by Karl Mounguengui Nguema on 2015-08-19.
//  Copyright (c) 2015 Karl Mounguengui. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var displayModalTimer: NSTimer!
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        AppData.sharedInstance.activityIndicatorView = STActivityIndicatorView(frame: UIScreen.mainScreen().bounds)

        self.setupCacheStorages ()

        GMSServices.provideAPIKey(kGOOGLEMAPS_API_KEY)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppDelegate.hideModalAddViewController), name:kHideModalAddNotification, object: nil)

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

        self.displayModalTimer?.invalidate()
        self.displayModalTimer = nil
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

        self.displayModalTimer = NSTimer.scheduledTimerWithTimeInterval(kDisplayCustomAdTimer, target:self, selector: #selector(AppDelegate.updateDisplayModal), userInfo: nil, repeats: true)
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    //MARK: - custom ads modal Methods
    func updateDisplayModal() -> Void {
        guard AppData.sharedInstance.customAdOnDisplay == false else { return }

        NSNotificationCenter.defaultCenter().postNotificationName(kDisplayModalAddNotification, object: nil)
        self.displayModalTimer?.invalidate()
        self.displayModalTimer = nil
    }

    func hideModalAddViewController() {
        self.displayModalTimer = NSTimer.scheduledTimerWithTimeInterval(kDisplayCustomAdTimer, target:self, selector: #selector(AppDelegate.updateDisplayModal), userInfo: nil, repeats: true)
    }
    
    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "ImagiN.Temp" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("FrismartModels", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }

        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }

    // MARK: - Private Core Data manipulation methods

    internal func locallySaveOfflineModeData() {
        // Delete all previously locally stored data
        self.deleteLocalAllCoreDataEntries()

        // locally store all offline data
        self.locallyStoreDataForOfflineMode()
    }

    internal func loadOfflineModeData() {
        // Make sure we empty out all old previously loaded data
        AppData.sharedInstance.stores.removeAll()
        AppData.sharedInstance.topStores.removeAll()

        AppData.sharedInstance.photos.removeAll()

        AppData.sharedInstance.categories.removeAll()
        AppData.sharedInstance.topCategories.removeAll()

        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest()

        // Create Entity Description
        var entityDescription = NSEntityDescription.entityForName("Store", inManagedObjectContext: self.managedObjectContext)

        // Configure Fetch Request
        fetchRequest.entity = entityDescription

        do {
            let result = try self.managedObjectContext.executeFetchRequest(fetchRequest)

            for index in 0..<result.count {
                let storeEntity = result[index] as! Store
                let loadedStoreEntry = STStore()

                loadedStoreEntry.store_id = storeEntity.store_id!
                loadedStoreEntry.icon_id = storeEntity.icon_id!
                loadedStoreEntry.category_id = storeEntity.category_id!
                loadedStoreEntry.email = storeEntity.email!
                loadedStoreEntry.sms_no = storeEntity.sms_no!
                loadedStoreEntry.lon = storeEntity.lon!
                loadedStoreEntry.lat = storeEntity.lat!
                loadedStoreEntry.store_desc = storeEntity.store_desc!
                loadedStoreEntry.store_address = storeEntity.store_address!
                loadedStoreEntry.store_name = storeEntity.store_name!
                loadedStoreEntry.rating_count = storeEntity.rating_count!
                loadedStoreEntry.featured = storeEntity.featured!
                loadedStoreEntry.updated_at = storeEntity.updated_at!
                loadedStoreEntry.created_at = storeEntity.created_at!
                loadedStoreEntry.rating_total = storeEntity.rating_total!
                loadedStoreEntry.website = storeEntity.website!
                loadedStoreEntry.distance = storeEntity.distance!
                loadedStoreEntry.is_deleted = storeEntity.is_deleted!
                loadedStoreEntry.horaire = storeEntity.horaire!
                loadedStoreEntry.website = storeEntity.website!

                AppData.sharedInstance.stores.append(loadedStoreEntry)
            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }

        // Use Entity Description
        entityDescription = NSEntityDescription.entityForName("TopStore", inManagedObjectContext: self.managedObjectContext)

        // Configure Fetch Request
        fetchRequest.entity = entityDescription

        do {
            let result = try self.managedObjectContext.executeFetchRequest(fetchRequest)

            for index in 0..<result.count {
                let storeEntity = result[index] as! TopStore
                let loadedStoreEntry = STStore()

                loadedStoreEntry.store_id = storeEntity.store_id!
                loadedStoreEntry.icon_id = storeEntity.icon_id!
                loadedStoreEntry.category_id = storeEntity.category_id!
                loadedStoreEntry.email = storeEntity.email!
                loadedStoreEntry.sms_no = storeEntity.sms_no!
                loadedStoreEntry.lon = storeEntity.lon!
                loadedStoreEntry.lat = storeEntity.lat!
                loadedStoreEntry.store_desc = storeEntity.store_desc!
                loadedStoreEntry.store_address = storeEntity.store_address!
                loadedStoreEntry.store_name = storeEntity.store_name!
                loadedStoreEntry.rating_count = storeEntity.rating_count!
                loadedStoreEntry.featured = storeEntity.featured!
                loadedStoreEntry.updated_at = storeEntity.updated_at!
                loadedStoreEntry.created_at = storeEntity.created_at!
                loadedStoreEntry.rating_total = storeEntity.rating_total!
                loadedStoreEntry.website = storeEntity.website!
                loadedStoreEntry.distance = storeEntity.distance!
                loadedStoreEntry.is_deleted = storeEntity.is_deleted!
                loadedStoreEntry.horaire = storeEntity.horaire!
                loadedStoreEntry.website = storeEntity.website!

                AppData.sharedInstance.topStores.append(loadedStoreEntry)
            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }

        // Use Entity Description
        entityDescription = NSEntityDescription.entityForName("Photo", inManagedObjectContext: self.managedObjectContext)

        // Configure Fetch Request
        fetchRequest.entity = entityDescription

        do {
            let result = try self.managedObjectContext.executeFetchRequest(fetchRequest)

            for index in 0..<result.count {
                let photoEntity = result[index] as! Photo
                let loadedPhotoEntry = STPhoto()

                loadedPhotoEntry.photo_url = photoEntity.photo_url!
                loadedPhotoEntry.created_at = photoEntity.created_at!
                loadedPhotoEntry.photo_id = photoEntity.photo_id!
                loadedPhotoEntry.thumb_url = photoEntity.thumb_url!
                loadedPhotoEntry.is_deleted = photoEntity.is_deleted!
                loadedPhotoEntry.updated_at = photoEntity.updated_at!
                loadedPhotoEntry.store_id = photoEntity.store_id!

                AppData.sharedInstance.photos.append(loadedPhotoEntry)
            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }

        // Use Entity Description
        entityDescription = NSEntityDescription.entityForName("Category", inManagedObjectContext: self.managedObjectContext)

        // Configure Fetch Request
        fetchRequest.entity = entityDescription

        do {
            let result = try self.managedObjectContext.executeFetchRequest(fetchRequest)

            for index in 0..<result.count {
                let categoryEntity = result[index] as! Category
                let loadedCategoryEntry = STCategory()

                loadedCategoryEntry.feat = categoryEntity.feat!
                loadedCategoryEntry.desc = categoryEntity.desc!
                loadedCategoryEntry.category_id = categoryEntity.category_id!
                loadedCategoryEntry.category_desc = categoryEntity.category_desc!
                loadedCategoryEntry.category_icon = categoryEntity.category_icon!
                loadedCategoryEntry.created_at = categoryEntity.created_at!
                loadedCategoryEntry.is_deleted = categoryEntity.is_deleted!
                loadedCategoryEntry.updated_at = categoryEntity.updated_at!
                loadedCategoryEntry.keywords = categoryEntity.keywords!
                loadedCategoryEntry.category_name = categoryEntity.category_name!
                loadedCategoryEntry.og_img = categoryEntity.og_img!

                AppData.sharedInstance.categories.append(loadedCategoryEntry)
            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }

        // Use Entity Description
        entityDescription = NSEntityDescription.entityForName("TopCategory", inManagedObjectContext: self.managedObjectContext)

        // Configure Fetch Request
        fetchRequest.entity = entityDescription

        do {
            let result = try self.managedObjectContext.executeFetchRequest(fetchRequest)

            for index in 0..<result.count {
                let categoryEntity = result[index] as! TopCategory
                let loadedCategoryEntry = STCategory()

                loadedCategoryEntry.feat = categoryEntity.feat!
                loadedCategoryEntry.desc = categoryEntity.desc!
                loadedCategoryEntry.category_id = categoryEntity.category_id!
                loadedCategoryEntry.category_desc = categoryEntity.category_desc!
                loadedCategoryEntry.category_icon = categoryEntity.category_icon!
                loadedCategoryEntry.created_at = categoryEntity.created_at!
                loadedCategoryEntry.is_deleted = categoryEntity.is_deleted!
                loadedCategoryEntry.updated_at = categoryEntity.updated_at!
                loadedCategoryEntry.keywords = categoryEntity.keywords!
                loadedCategoryEntry.category_name = categoryEntity.category_name!
                loadedCategoryEntry.og_img = categoryEntity.og_img!

                AppData.sharedInstance.topCategories.append(loadedCategoryEntry)
            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    }

    private func locallyStoreDataForOfflineMode() {
        let context: NSManagedObjectContext = self.managedObjectContext

        for store in AppData.sharedInstance.stores {
            let addEntityDescription = NSEntityDescription.entityForName("Store", inManagedObjectContext: context)
            let newStore = Store(entity: addEntityDescription!, insertIntoManagedObjectContext: context)

            newStore.store_id = store.store_id
            newStore.icon_id = store.icon_id
            newStore.category_id = store.category_id
            newStore.email = store.email
            newStore.sms_no = store.sms_no
            newStore.lon = store.lon
            newStore.lat = store.lat
            newStore.store_desc = store.store_desc
            newStore.store_address = store.store_address
            newStore.store_name = store.store_name
            newStore.rating_count = store.rating_count
            newStore.featured = store.featured
            newStore.updated_at = store.updated_at
            newStore.created_at = store.created_at
            newStore.rating_total = store.rating_total
            newStore.website = store.website
            newStore.distance = store.distance
            newStore.is_deleted = store.is_deleted
            newStore.horaire = store.horaire
            newStore.website = store.website
        }

        for store in AppData.sharedInstance.topStores {
            let addEntityDescription = NSEntityDescription.entityForName("TopStore", inManagedObjectContext: context)
            let newStore = TopStore(entity: addEntityDescription!, insertIntoManagedObjectContext: context)

            newStore.store_id = store.store_id
            newStore.icon_id = store.icon_id
            newStore.category_id = store.category_id
            newStore.email = store.email
            newStore.sms_no = store.sms_no
            newStore.lon = store.lon
            newStore.lat = store.lat
            newStore.store_desc = store.store_desc
            newStore.store_address = store.store_address
            newStore.store_name = store.store_name
            newStore.rating_count = store.rating_count
            newStore.featured = store.featured
            newStore.updated_at = store.updated_at
            newStore.created_at = store.created_at
            newStore.rating_total = store.rating_total
            newStore.website = store.website
            newStore.distance = store.distance
            newStore.is_deleted = store.is_deleted
            newStore.horaire = store.horaire
            newStore.website = store.website
        }

        for photo in AppData.sharedInstance.photos {
            let addEntityDescription = NSEntityDescription.entityForName("Photo", inManagedObjectContext: context)
            let newPhoto = Photo(entity: addEntityDescription!, insertIntoManagedObjectContext: context)

            newPhoto.photo_url = photo.photo_url
            newPhoto.created_at = photo.created_at
            newPhoto.photo_id = photo.photo_id
            newPhoto.thumb_url = photo.thumb_url
            newPhoto.is_deleted = photo.is_deleted
            newPhoto.updated_at = photo.updated_at
            newPhoto.store_id = photo.store_id
        }

        for category in AppData.sharedInstance.categories {
            let addEntityDescription = NSEntityDescription.entityForName("Category", inManagedObjectContext: context)
            let newCategory = Category(entity: addEntityDescription!, insertIntoManagedObjectContext: context)

            newCategory.feat = category.feat
            newCategory.desc = category.desc
            newCategory.category_id = category.category_id
            newCategory.category_desc = category.category_desc
            newCategory.category_icon = category.category_icon
            newCategory.created_at = category.created_at
            newCategory.is_deleted = category.is_deleted
            newCategory.updated_at = category.updated_at
            newCategory.keywords = category.keywords
            newCategory.category_name = category.category_name
            newCategory.og_img = category.og_img
        }

        for category in AppData.sharedInstance.topCategories {
            let addEntityDescription = NSEntityDescription.entityForName("TopCategory", inManagedObjectContext: context)
            let newCategory = TopCategory(entity: addEntityDescription!, insertIntoManagedObjectContext: context)

            newCategory.feat = category.feat
            newCategory.desc = category.desc
            newCategory.category_id = category.category_id
            newCategory.category_desc = category.category_desc
            newCategory.category_icon = category.category_icon
            newCategory.created_at = category.created_at
            newCategory.is_deleted = category.is_deleted
            newCategory.updated_at = category.updated_at
            newCategory.keywords = category.keywords
            newCategory.category_name = category.category_name
            newCategory.og_img = category.og_img
        }

        self.saveContext()
    }

    private func deleteLocalAllCoreDataEntries() {
        self.deleteAllData("Store")
        self.deleteAllData("TopStore")

        self.deleteAllData("Category")
        self.deleteAllData("TopCategory")

        self.deleteAllData("Photo")        

        self.saveContext()
    }

    // NOTE: There's a better iOS 9+ solution but can't use it for now since this app supports
    //       iOS 8+ still
    private func deleteAllData(entity: String) {
        self.managedObjectContext.performBlockAndWait{
            let fetchRequest = NSFetchRequest(entityName: entity)
            fetchRequest.returnsObjectsAsFaults = false

            do
            {
                let results = try self.managedObjectContext.executeFetchRequest(fetchRequest)

                for managedObject in results {
                    if let managedObjectData = managedObject as? NSManagedObject {
                        self.managedObjectContext.deleteObject(managedObjectData)
                    }
                }
            } catch let error as NSError {
                print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
            }
        }
    }

    // MARK: - Private methods

    private func setupCacheStorages() -> Void {
        // Enable disk caching for NSURLConnection & NSURLSession
        let cacheSizeMemory : Int = Int(4 * 1024 * 1024)    // 4 MB
        let diskCapacity : Int = Int(256 * 1024 * 1024)     // 256 MB
        let cache : NSURLCache = NSURLCache(memoryCapacity: cacheSizeMemory, diskCapacity: diskCapacity, diskPath: "Frismart_256_Cache.db")
        NSURLCache.setSharedURLCache(cache)

        // NOTE: perform sleep() to allow big cache file to be created (as seen in a discussion in stackoverflow)
        sleep(1)
    }

}
