//
//  Person+CoreDataProperties.swift
//  
//
//  Created by Владимир Моисеев on 19.02.2018.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var id: String?
    @NSManaged public var positive: [String]?
    @NSManaged public var negative: [String]?
}
