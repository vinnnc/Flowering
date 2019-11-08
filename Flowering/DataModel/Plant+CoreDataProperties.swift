//
//  Plant+CoreDataProperties.swift
//  Flowering
//
//  Created by Wenchu Du on 8/11/19.
//  Copyright © 2019 Personal. All rights reserved.
//
//

import Foundation
import CoreData


extension Plant {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Plant> {
        return NSFetchRequest<Plant>(entityName: "Plant")
    }

    @NSManaged public var fertility: Int32
    @NSManaged public var image: String?
    @NSManaged public var moisture: Int32
    @NSManaged public var name: String?
    @NSManaged public var sunshine: Int32
    @NSManaged public var temperature: Int32

}
