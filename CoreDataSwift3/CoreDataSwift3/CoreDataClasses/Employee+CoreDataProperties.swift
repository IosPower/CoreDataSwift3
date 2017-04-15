//
//  Employee+CoreDataProperties.swift
//  CoreDataSwift3
//
//  Created by piyush sinroja on 12/04/17.
//  Copyright © 2017 Piyush. All rights reserved.
//

import Foundation
import CoreData


extension Employee {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Employee> {
        return NSFetchRequest<Employee>(entityName: "Employee");
    }
    @NSManaged public var empId: Int64
    @NSManaged public var empName: String?
    @NSManaged public var empSurname: String?
    @NSManaged public var empSalary: String?
    @NSManaged public var empImage: String?
    @NSManaged public var empStatus: String?
    @NSManaged public var empDepartment: String?
    @NSManaged public var status: Status?
    @NSManaged public var location: Location?
    @NSManaged public var department: Department?
}
