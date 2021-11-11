//
//  DataControllerClass.swift
//  VirtualTourist2.0
//
//  Created by Zakaria on 11/11/2021.
//

import Foundation
import CoreData



// MARK: - Main DataControllerClass
class DataControllerClass{
    let persistentContainer : NSPersistentContainer
    
    var viewContext : NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(modelName : String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    

    func load(completion: (()-> Void)? = nil){
        persistentContainer.loadPersistentStores { storeDescription, error in
            guard error == nil else  {
                fatalError("Error from data controller class load function  \(error!.localizedDescription)")
            }
            self.autoSaveTheViewContext()
            completion?()
        }
    }
    
}


// MARK: - Extension for DataControllerClass
extension  DataControllerClass {
    

    
    func autoSaveTheViewContext(interval : TimeInterval = 30){
        // check if the interval is positive
        guard interval > 0 else {
            print("Cannot autosave in negative interval ")
            return
        }
        
        // check if the viewContext has changes and if there are changes then save
        if viewContext.hasChanges {
            try? viewContext.save()
        }
        
        //Dispatch on the main thread after async
        DispatchQueue.main.asyncAfter(deadline: .now() + interval){
            self.autoSaveTheViewContext(interval: interval)
        }
        
        // test the autosave
        print("autosaving in progess")
        
    }
    
}
