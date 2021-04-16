//
//  CoreDataHelper.swift
//  VeloToApp
//
//  Created by Максим Газимзянов on 14.04.2021.
//

import Foundation
import CoreData

struct CoreDataHelper {
    
    private static let context: NSManagedObjectContext = {
        let container = NSPersistentContainer(name: "VeloToDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container.viewContext
    }()
    
    static func new<T: NSManagedObject>(name: String) -> T {
        return NSEntityDescription.insertNewObject(forEntityName: name, into: context) as! T
    }
    
    static func save() {
        do {
            try context.save()
        } catch let error {
            context.rollback()
            print("Unable to save context: \(error.localizedDescription)")
        }
    }
    
    static func delete<T: NSManagedObject>(entity: T) {
        context.delete(entity)
        save()
    }
    
    static func retrieveAll<T: NSManagedObject>(name: String) -> [T]? {
        do {
            let request = NSFetchRequest<T>(entityName: name)
            return try context.fetch(request)
        } catch let error {
            print("Unable to fetch Notes: \(error.localizedDescription)")
            return nil
        }
    }
}
