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
        entity.id = response.id
        entity.name = response.name
        entity.comment = response.comment
        entity.every = response.every
        entity.remain = response.remain
        CoreDataHelper.save()
    }
    
    static func persistNew(id: Int64, name: String, every: Int64, remain: Int64, comment: String) {
        let entity = new()
        entity.id = id
        entity.name = name
        entity.comment = comment
        entity.every = every
        entity.remain = remain
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
    
    static func deleteById(_ id: Int64) {
        if let entity = find(by: id) {
            delete(entity: entity)
        } else {
            print("Didn't find entity: \(id)")
        }
    }
    
    static func deleteAll() {
        CoreDataHelper.deleteAll(of: entityName)
    }
    
    static func find(by uniqueField: Any) -> AthleteTask? {
        return CoreDataHelper.findOne(entityName, with: "id == %@", arguments: [uniqueField])
    }
    
    static func retrieveAll() -> [AthleteTask]? {
        return CoreDataHelper.retrieveAll(name: entityName)
    }
    
    static func resetRemainFor(task: AthleteTask) {
        task.remain = task.every
        CoreDataHelper.save()
    }

}
