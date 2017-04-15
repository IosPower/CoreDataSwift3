//
//  CoreDataHelper.swift
//  CoreDataSwift3
//
//  Created by piyush sinroja on 11/04/17.
//  Copyright © 2017 Piyush. All rights reserved.
//

import UIKit
import CoreData

class CoreDataHelper: NSObject {

    // MARK: - Core Data stack
   let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "CoreDataSwift3")
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
    
    // MARK: - Core Data Saving support
    
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
    
    func saveData(entityName: String, dicParameter: NSDictionary) {
        // SAVE DATA
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.coredataHelperobj.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedObjectContext)
        
        let managedObject = NSManagedObject(entity: entity!, insertInto: managedObjectContext)
        
        for (key, value) in dicParameter {
            let strKey = key as! String
            managedObject.setValue(value, forKey: strKey)
        }
        do {
            try managedObjectContext.save()
        }
        catch let error as NSError {
            print(error)
        }
    }
    
    
    func getEntityObjectForRelation(entityName: String, dicParameter: NSDictionary)-> NSManagedObject {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.coredataHelperobj.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedObjectContext)
        
        let managedObject = NSManagedObject(entity: entity!, insertInto: managedObjectContext)
        
        for (key, value) in dicParameter {
            let strKey = key as! String
            managedObject.setValue(value, forKey: strKey)
        }
        return managedObject
    }

    
    func updateData(entityName: String, dicParameter: NSDictionary, objforUpdate: NSManagedObject) {
        // updateData
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.coredataHelperobj.persistentContainer.viewContext
        for (key, value) in dicParameter {
            let strKey = key as! String
            objforUpdate.setValue(value, forKey: strKey)
        }
        do {
            try managedObjectContext.save()
        }
        catch let error as NSError {
            print(error)
        }
    }
}

//MARK:- Employee GetData
extension Employee {
    public class func getDataFromEmployee()->[Employee] {
        // GET DATA
        var arrayEmployee = [Employee]()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.coredataHelperobj.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Employee> = Employee.fetchRequest()
        do {
            let results = try managedContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            arrayEmployee = results as! [Employee]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return arrayEmployee
    }

    public class func getFilteredDataFromEmployee(dicForFilter: NSDictionary?)->[Employee] {
        // GET DATA
        var arrayEmployee = [Employee]()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.coredataHelperobj.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Employee> = Employee.fetchRequest()
        do {
            if dicForFilter != nil {
                var arrayPredicate = [NSPredicate]()
                for (key,value) in dicForFilter! {
                    let strKey = key as! String
                    let strValue = value as! String
                    arrayPredicate.append(NSPredicate(format: "%K == %@",strKey,strValue))
                }
            
                let predicateObj = NSCompoundPredicate(andPredicateWithSubpredicates: arrayPredicate)
                //  let prednew = NSPredicate(format: "%K == %@ AND %K == %@","empName","Ramesh","empDepartment","QA")
                 fetchRequest.predicate = predicateObj
            }
            //seemore Filter option in
            //http://www.learncoredata.com/filtering-data-with-nspredicate/
            let results = try managedContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            arrayEmployee = results as! [Employee]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return arrayEmployee
    }
}

//MARK:- Department GetData
extension Department {
    public class func getDataFromDepartment()->[Department] {
        // GET DATA
        var arrayCategory = [Department]()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.coredataHelperobj.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Department> = Department.fetchRequest()
        do {
            let results = try managedContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            arrayCategory = results as! [Department]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return arrayCategory
    }
}

//MARK:- Status GetData
extension Status {
    public class func getDataFromStatus()->[Status] {
        // GET DATA
        var arrayStatus = [Status]()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.coredataHelperobj.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Status> = Status.fetchRequest()
        do {
            let results = try managedContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            arrayStatus = results as! [Status]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return arrayStatus
    }
}

//MARK:- Location GetData
extension Location {
    public class func getDataFromLocation()->[Location] {
        // GET DATA
        var arrayLocation = [Location]()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.coredataHelperobj.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        do {
            let results = try managedContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            arrayLocation = results as! [Location]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return arrayLocation
    }
}
