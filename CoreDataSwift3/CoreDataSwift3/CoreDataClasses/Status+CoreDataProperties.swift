//
//  Status+CoreDataProperties.swift
//  CoreDataSwift3
//
//  Created by piyush sinroja on 12/04/17.
//  Copyright © 2017 Piyush. All rights reserved.
//

import Foundation
import CoreData


extension Status {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Status> {
        return NSFetchRequest<Status>(entityName: "Status");
    }

    @NSManaged public var isAvailable: Bool
    @NSManaged public var employee: Employee?

}
