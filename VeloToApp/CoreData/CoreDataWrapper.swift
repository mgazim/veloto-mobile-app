//
//  CoreDataWrapper.swift
//  VeloToApp
//
//  Created by Максим Газимзянов on 20.04.2021.
//

import Foundation
import CoreData

protocol CoreDataWrapper {
    
    associatedtype T : NSManagedObject
    
    static func new() -> T
    
    static func delete(entity: T)
    
    static func deleteAll()

    static func find(by uniqueField: Any) -> T?
    
    static func retrieveAll() -> [T]?

}
