//
//  Department+CoreDataProperties.swift
//  CoreDataSwift3
//
//  Created by piyush sinroja on 12/04/17.
//  Copyright © 2017 Piyush. All rights reserved.
//

import Foundation
import CoreData


extension Department {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Department> {
        return NSFetchRequest<Department>(entityName: "Department");
    }

    @NSManaged public var empDepartment: String?
    @NSManaged public var employee: Employee?

}
