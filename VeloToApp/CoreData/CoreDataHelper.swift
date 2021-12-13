//
//  CoreDataHelper.swift
//  VeloToApp
//
//  Created by Максим Газимзянов on 14.04.2021.
//

import Foundation
import CoreData

final class CoreDataHelper {
    
    static let modelName = "VeloToDataModel"
    
    /*private(set) static var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        return managedObjectContext
    }()

    private static var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd") else {
            fatalError("Unable to Find Data Model")
        }
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to Load Data Model")
        }
        return managedObjectModel
    }()

    private static var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        let fileManager = FileManager.default
        let storeName = "\(modelName).sqlite"
        let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: persistentStoreURL, options: nil)
        } catch {
            fatalError("Unable to Load Persistent Store")
        }
        return persistentStoreCoordinator
    }()*/
    
    private static let managedObjectContext: NSManagedObjectContext = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container.viewContext
    }()
    
    static func new<T: NSManagedObject>(entityName: String) -> T {
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: managedObjectContext) as! T
    }

    static func findOne<T: NSManagedObject>(_ entityName: String, with predicate: String, arguments: [Any]?) -> T? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: predicate, argumentArray: arguments)
        do {
            let result = try managedObjectContext.fetch(fetchRequest)
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
            try managedObjectContext.save()
        } catch let error {
            managedObjectContext.rollback()
            print("Unable to save context: \(error.localizedDescription)")
        }
    }
    
    static func delete<T: NSManagedObject>(entity: T) {
        managedObjectContext.delete(entity)
        save()
    }
    
    static func deleteAll(of entityName: String) {
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            try managedObjectContext.executeAndMergeChanges(using: batchDeleteRequest)
        } catch let error {
            print("Unable to delete all: \(error.localizedDescription)")
            managedObjectContext.rollback()
        }
    }
    
    static func retrieveAll<T: NSManagedObject>(name: String) -> [T]? {
        do {
            let request = NSFetchRequest<T>(entityName: name)
            return try managedObjectContext.fetch(request)
        } catch let error {
            print("Unable to fetch Notes: \(error.localizedDescription)")
            return nil
        }
    }
    
    static func retrieveAll<T: NSManagedObject>(name: String, with predicate: String, arguments: [Any]?) -> [T]? {
        do {
            let request = NSFetchRequest<T>(entityName: name)
            request.predicate = NSPredicate(format: predicate, argumentArray: arguments)
            return try managedObjectContext.fetch(request)
        } catch let error {
            print("Unable to fetch: \(error.localizedDescription)")
            return nil
        }
    }

}

extension NSManagedObjectContext {
    public func executeAndMergeChanges(using batchDeleteRequest: NSBatchDeleteRequest) throws {
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        let result = try execute(batchDeleteRequest) as? NSBatchDeleteResult
        let changes: [AnyHashable: Any] = [NSDeletedObjectsKey: result?.result as? [NSManagedObjectID] ?? []]
        NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [self])
    }
}
