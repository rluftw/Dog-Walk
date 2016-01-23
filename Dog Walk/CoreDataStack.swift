//
//  CoreDataStack.swift
//  Dog Walk
//
//  Created by Xing Hui Lu on 1/22/16.
//  Copyright © 2016 Razeware. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    /*
        Setting the name of your future managed object model, “Dog Walk”, on a property.
    */
    
    let modelName = "Dog Walk"
    
    private lazy var applicationDocumentsDicrectory: NSURL = {
        /*
            Store the SQLite database (which is simply a file) in the documents directory. 
            This is the recommended place to store the user’s data.
        */
        
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    /*
        1. Your managed context isn’t very useful until you connect it to an NSPersistentStoreCoordinator.
        You do this by setting the managed context’s persistentStoreCoordinator property to stack’s store coordinator.
    */
    
    lazy var context: NSManagedObjectContext = {
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.psc
        return managedObjectContext
    }()
    
    /*
        2. The store coordinator mediates between the NSManagedObjectModel and the persistent store(s), 
        so you’ll need to create a managed model and at least one persistent store.
    
        You don’t initialize the persistent store directly. Instead, the persistent store coordinator hands you an NSPersistentStore
        object as a side effect of attaching a persistent store type. You simply have to specify the store type (NSSQLiteStoreType in this case),
        the URL location of the store file and some configuration options.
    */
    
    private lazy var psc: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDicrectory.URLByAppendingPathComponent(self.modelName)
        
        do {
            let options = [NSMigratePersistentStoresAutomaticallyOption: true]
            
            /* Adding the persistent store */
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: options)
        } catch {
            print("Error adding persistent store.")
        }
        
        return coordinator
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle().URLForResource(self.modelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    /*
        A convenience method to save the stack’s managed object context and handle any errors that might result
    */
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError {
                print("Error: \(error.localizedDescription)")
                abort()
            }
        }
    }
}