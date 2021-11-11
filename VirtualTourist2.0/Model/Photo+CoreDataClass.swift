//
//  Photo+CoreDataClass.swift
//  VirtualTourist2.0
//
//  Created by Zakaria on 11/11/2021.
//

import Foundation
import CoreData



public class Photo : NSManagedObject{
    convenience init(imageURL: String?, context: NSManagedObjectContext) {
        if let entityToCreate = NSEntityDescription.entity(forEntityName: "Photo", in: context){
            
            self.init(entity: entityToCreate, insertInto: context)
            self.imageURL = imageURL
        } else {
            fatalError("Cant find entity name - photo")
        }
}
}
