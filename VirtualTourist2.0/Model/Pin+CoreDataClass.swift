//
//  Pin+CoreDataClass.swift
//  VirtualTourist2.0
//
//  Created by Zakaria on 11/11/2021.
//

import Foundation
import CoreData

//public class Pin: NSManagedObject {
//
//    // task: crear un inicializador para generar las instancias de 'Pin'
//    // este inicializador tomará los datos de las coordenadas del pin puesto
//    convenience init(latitude: Double, longitude: Double, context: NSManagedObjectContext) {
//
//        if let ent = NSEntityDescription.entity(forEntityName: "Pin", in: context) {
//
//            self.init(entity: ent, insertInto: context)
//            self.latitude = latitude
//            self.longitude = longitude
//
//        } else {
//
//            fatalError("Unable To Find Entity Name!")
//        }
//    }
//
//}

public class Pin : NSManagedObject {
    convenience init(latitude: Double, longitude: Double, context: NSManagedObjectContext){
//        if let entityToCreate =  NSEntityDescription()
    }
}
