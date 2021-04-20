//
//  AthleteCoreDataWrapper.swift
//  VeloToApp
//
//  Created by Максим Газимзянов on 20.04.2021.
//

import Foundation

struct AthleteCoreDataWrapper: CoreDataWrapper {
    
    typealias T = Athlete
    
    static let entityName = "Athlete"
    
    static func new() -> Athlete {
        return CoreDataHelper.new(entityName: entityName)
    }
    
    static func delete(entity: Athlete) {
        CoreDataHelper.delete(entity: entity)
    }
    
    static func deleteAll() {
        CoreDataHelper.deleteAll(of: entityName)
    }
    
    static func find(by uniqueField: Any) -> Athlete? {
        return CoreDataHelper.findOne(entityName, with: "id == %@", arguments: [uniqueField]) as? Athlete
    }
    
    static func retrieveAll() -> [Athlete]? {
        return CoreDataHelper.retrieveAll(name: entityName)
    }
}
