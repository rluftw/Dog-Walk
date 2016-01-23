//
//  AppDelegate.swift
//  Dog Walk
//
//  Created by Pietro Rea on 7/17/15.
//  Copyright © 2015 Razeware. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    /*
        You initialize the Core Data stack object as a lazy variable on the application delegate. 
        This means the stack won’t be set up until the first time you access the property.
    */
    lazy var coreDataStack = CoreDataStack()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let navigationController = window?.rootViewController as! UINavigationController
        let viewController = navigationController.topViewController as! ViewController
            
        viewController.managedContext = coreDataStack.context
            
        return true
    }
  
    /*
        These methods ensure that Core Data saves any pending changes before the app is either sent to the 
        background or terminated for whatever reason.
    */
    
    func applicationDidEnterBackground(application: UIApplication) {
        coreDataStack.saveContext()
    }
    
    func applicationWillTerminate(application: UIApplication) {
        coreDataStack.saveContext()
    }
}

