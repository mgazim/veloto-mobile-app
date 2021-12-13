//
//  ActionCardsCoreDataWrapper.swift
//  VeloToApp
//
//  Created by Максим Газимзянов on 24.04.2021.
//

import Foundation

struct AthleteTaskCoreDataWrapper: CoreDataWrapper {
    
    typealias T = AthleteTask
    
    static let entityName = "AthleteTask"
    
    static func persistNew(from response: TaskResponse) {
        let entity = new()
        entity.name = response.name
        entity.comment = response.comment
        entity.checkValue = response.every
        entity.left = entity.checkValue
        CoreDataHelper.save()
    }
    
    static func persistAll(of tasks: [TaskResponse]) {
        for task in tasks {
            persistNew(from: task)
        }
    }
    
    static func retainAll(of tasks: [TaskResponse]) {
        deleteAll()
        for task in tasks {
            persistNew(from: task)
        }
    }
    
    static func new() -> AthleteTask {
        return CoreDataHelper.new(entityName: entityName)
    }
    
    static func delete(entity: AthleteTask) {
        CoreDataHelper.delete(entity: entity)
    }
    
    static func deleteAll() {
        CoreDataHelper.deleteAll(of: entityName)
    }
    
    // todo: use really unique field
    static func find(by uniqueField: Any) -> AthleteTask? {
        return CoreDataHelper.findOne(entityName, with: "name == %@", arguments: [uniqueField])
    }
    
    static func retrieveAll() -> [AthleteTask]? {
        return CoreDataHelper.retrieveAll(name: entityName)
    }

}
