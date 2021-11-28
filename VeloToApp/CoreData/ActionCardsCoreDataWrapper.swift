//
//  ActionCardsCoreDataWrapper.swift
//  VeloToApp
//
//  Created by Максим Газимзянов on 24.04.2021.
//

import Foundation

struct ActionCardsCoreDataWrapper: CoreDataWrapper {
    
    typealias T = ActionCard
    
    static let entityName = "ActionCard"
    
    static func new() -> ActionCard {
        return CoreDataHelper.new(entityName: entityName)
    }
    
    static func delete(entity: ActionCard) {
        CoreDataHelper.delete(entity: entity)
    }
    
    static func deleteAll() {
        CoreDataHelper.deleteAll(of: entityName)
    }
    
    // todo: use really unique field
    static func find(by uniqueField: Any) -> ActionCard? {
        return CoreDataHelper.findOne(entityName, with: "name == %@", arguments: [uniqueField])
    }
    
    static func retrieveAll() -> [ActionCard]? {
        return CoreDataHelper.retrieveAll(name: entityName)
    }
    
    static func retrieveAllForAthleteID(id athlete: Int64) -> [ActionCard]? {
        return CoreDataHelper.retrieveAll(name: entityName, with: "athlete.id == %@", arguments: [athlete])
    }

}
