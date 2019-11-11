//
//  FarmDate+CoreDataProperties.swift
//  Flowering
//
//  Created by Wenchu Du on 11/11/19.
//  Copyright © 2019 Personal. All rights reserved.
//
//

import Foundation
import CoreData


extension FarmDate {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FarmDate> {
        return NSFetchRequest<FarmDate>(entityName: "FarmDate")
    }

    @NSManaged public var day: Int16
    @NSManaged public var fert: Bool
    @NSManaged public var month: Int16
    @NSManaged public var water: Bool
    @NSManaged public var year: Int16

}
