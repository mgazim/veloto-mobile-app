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
    
    static func new<T: NSManagedObject>(entityName: String) -> T {
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as! T
    }

    static func findOne<T: NSManagedObject>(_ entityName: String, with predicate: String, arguments: [Any]?) -> T? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: predicate, argumentArray: arguments)
        do {
            let result = try context.fetch(fetchRequest)
            if result.count == 1 {
                return result[0] as? T
            } else {
                return nil
            }
        } catch let error {
            print("Error: Cannot retrieve object \(error.localizedDescription)")
        }
        return nil
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
    
    static func deleteAll(of entityName: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(batchDeleteRequest)
        } catch let error {
            print("Error: Unable to remove entities of '\(entityName)': \(error.localizedDescription)")
        }
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
