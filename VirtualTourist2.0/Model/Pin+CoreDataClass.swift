//
//  Pin+CoreDataClass.swift
//  VirtualTourist2.0
//
//  Created by Zakaria on 11/11/2021.
//

import Foundation
import CoreData

public class Pin : NSManagedObject {
    
    convenience init(latitude: Double, longitude: Double, context:  NSManagedObjectContext) {
        if let entityToCreate = NSEntityDescription.entity(forEntityName: "Pin", in: context){
            self.init(entity: entityToCreate, insertInto: context)
            self.latitude = latitude
            self.longitude = longitude
        } else {
            fatalError("Cant find the entity name - pin")
        }
        
    }
    
}
