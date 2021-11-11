//
//  Pin+CoreDataProperties.swift
//  VirtualTourist2.0
//
//  Created by Zakaria on 11/11/2021.
//

import Foundation
import CoreData


extension Pin {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest <Pin>{
        return NSFetchRequest<Pin>(entityName: "Pin")
    }
    
    // Attributes
    @NSManaged public var latitude : Double
    @NSManaged public var longitude : Double
    
    // RelationShips
    @NSManaged public var photo: NSSet?
}






extension Pin{
    
    @objc(addPhotosOfObject:)
    @NSManaged public func addToPhotos(_value : Photo)
    
    @objc(removePhotosObject:)
    @NSManaged public func removeFromPhotos(_value: Photo)
    
    @objc(addPhotos:)
    @NSManaged public func addToPhotos(_values : NSSet)
    
    @objc(removePhotos:)
    @NSManaged public func removeFromPhotos(_ values: NSSet)
    
}
