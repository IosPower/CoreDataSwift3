//
//  Location+CoreDataProperties.swift
//  CoreDataSwift3
//
//  Created by piyush sinroja on 12/04/17.
//  Copyright © 2017 Piyush. All rights reserved.
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location");
    }

    @NSManaged public var city: String?
    @NSManaged public var employee: NSSet?

}

// MARK: Generated accessors for employee
extension Location {

    @objc(addEmployeeObject:)
    @NSManaged public func addToEmployee(_ value: Employee)

    @objc(removeEmployeeObject:)
    @NSManaged public func removeFromEmployee(_ value: Employee)

    @objc(addEmployee:)
    @NSManaged public func addToEmployee(_ values: NSSet)

    @objc(removeEmployee:)
    @NSManaged public func removeFromEmployee(_ values: NSSet)

}
