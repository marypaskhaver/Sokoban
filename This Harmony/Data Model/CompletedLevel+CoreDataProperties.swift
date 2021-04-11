//
//  CompletedLevel+CoreDataProperties.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 4/10/21.
//
//

import Foundation
import CoreData


extension CompletedLevel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CompletedLevel> {
        return NSFetchRequest<CompletedLevel>(entityName: "CompletedLevel")
    }

    @NSManaged public var lowestSteps: Int32
    @NSManaged public var levelNumber: Int32

}
