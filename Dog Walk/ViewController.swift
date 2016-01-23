//
//  ViewController.swift
//  Dog Walk
//
//  Created by Pietro Rea on 7/17/15.
//  Copyright © 2015 Razeware. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource {

    // MARK: - Class properties
    
    lazy var dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .MediumStyle
        return formatter
    }()

    
    var managedContext: NSManagedObjectContext!
    var currentDog: Dog!
    
    //MARK: - IBOutlets
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let dogEntity = NSEntityDescription.entityForName("Dog", inManagedObjectContext: managedContext)
        
        let dogName = "Fido"
        let dogFetch = NSFetchRequest(entityName: "Dog")
        dogFetch.predicate = NSPredicate(format: "name == %@", dogName)
        
        do {
            let results = try managedContext.executeFetchRequest(dogFetch) as! [Dog]
            
            /*
                Find or Create pattern
                ======================
            
                The purpose of this pattern is to manipulate an object stored in Core Data without 
                running the risk of adding a duplicate in the process.
            */
            
            if results.count > 0 {
                //Fido found, use Fido
                currentDog = results.first!
            } else {
                //Fido not found, create Fido
                currentDog = Dog(entity: dogEntity!, insertIntoManagedObjectContext: managedContext)
                currentDog.name = dogName
                try managedContext.save()
            }
        } catch let error as NSError {
            print("Error: \(error) Description \(error.localizedDescription)")
        }
    }

    // MARK: - Tableview datasource methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentDog.walks!.count
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "List of Walks"
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

        let walk =  currentDog.walks![indexPath.row] as! Walk
        cell.textLabel!.text = dateFormatter.stringFromDate(walk.date!)

        return cell
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            /*
                1. You get a reference to the walk you want to delete.
            */
            
            let walkToRemove = currentDog.walks![indexPath.row] as! Walk
            
            /*
                2. Remove the walk from Core Data by calling NSManagedObjectContext’s deleteObject method. 
                Core Data also takes care of removing the deleted walk from the current dog’s walks relationship.
            */
            
            managedContext.deleteObject(walkToRemove)
            
            /*
                3. No changes are final until you save your managed object context, not even deletions!
            */
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save: \(error)")
            }
            
            /*
                4. Finally, you animate the table view to tell the user about the deletion.
            */
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    // MARK: - Helper methods
    
    @IBAction func add(sender: AnyObject) {
        // Insert a new Walk entity into CoreData
        
        let walkEntity = NSEntityDescription.entityForName("Walk", inManagedObjectContext: managedContext)
        let walk = Walk(entity: walkEntity!, insertIntoManagedObjectContext: managedContext)
        
        walk.date = NSDate()
        
        //Insert the new Walk into the Dog's walks set
        
        let walks = currentDog.walks?.mutableCopy() as! NSMutableOrderedSet
        walks.addObject(walk)
        
        currentDog.walks = walks.copy() as? NSOrderedSet
        
        // Save the managed object context
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save: \(error)")
        }
        
        // Reload table view
        
        tableView.reloadData()
    }
}

