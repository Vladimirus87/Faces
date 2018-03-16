//
//  Person+CoreDataClass.swift
//  
//
//  Created by Владимир Моисеев on 19.02.2018.
//
//

import UIKit
import CoreData


public class Person: NSManagedObject {

    convenience init() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let contex = appDelegate.persistentContainer.viewContext
        
        self.init(entity: appDelegate.entityForName(entityName: "Person"), insertInto: contex)
    }
}
