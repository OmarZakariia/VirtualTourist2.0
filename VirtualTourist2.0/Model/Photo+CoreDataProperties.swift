//
//  Photo+CoreDataProperties.swift
//  VirtualTourist2.0
//
//  Created by Zakaria on 11/11/2021.
//

import Foundation
import CoreData
//extension Photo {
//
//        // busca si hay instancias persistidas del objeto 'Photo'
//    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
//        return NSFetchRequest<Photo>(entityName: "Photo")
//    }
//
//    @NSManaged public var imageData: NSData? // attribute
//    @NSManaged public var imageURL: String? // attribute
//    @NSManaged public var pin: Pin? // relationship
//
//}

extension Photo {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo>{
        return NSFetchRequest<Photo>(entityName: "Photo")
    }
    
    // Attributes
    @NSManaged public var imageData: NSData?
    @NSManaged public var imageURL: String?
    
    // Relationship
    @NSManaged public var pin: Pin?
}
