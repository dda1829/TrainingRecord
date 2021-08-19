//
//  CoreDataHelper.swift
//
//  Created by Vincent on 2018/03/15.
//
import UIKit
import CoreData

class CoreDataHelper: NSObject {
    
    static let shared = CoreDataHelper()
    
    override internal init() {
        
    }

    func managedObjectContext() -> NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "TrainingRecord")
        let description = NSPersistentStoreDescription()
        //設定sqlite存放位置
        var sqlUrl = URL(fileURLWithPath: NSHomeDirectory())
        sqlUrl.appendPathComponent("Documents")
        sqlUrl.appendPathComponent("RecordDatas.sqlite")//sqlite
        description.url = sqlUrl
        //如果要關閉journal mode，只產生一個sqlite檔案，可以打開這個選項
        //description.setOption(["journal_mode":"DELETE"] as NSDictionary, forKey: NSSQLitePragmasOption)
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
