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
    
    static func persistNew(from response: CreateUserResponse, with stravaId: Int64) {
        let entity = AthleteCoreDataWrapper.new()
        entity.id = response.userId
        entity.stravaId = stravaId
        entity.overallDistance = response.mileage
        CoreDataHelper.save()
    }
    
    static func new() -> Athlete {
        return CoreDataHelper.new(entityName: entityName)
    }
    
    static func delete(entity: Athlete) {
        CoreDataHelper.delete(entity: entity)
    }
    
    static func deleteAll() {
        CoreDataHelper.deleteAll(of: entityName)
    }
    
    static func get() -> Athlete? {
        if let athletes = retrieveAll() {
            if athletes.count > 1 {
                print("Something went wrong so we have two athlets, re-authenticate")
                deleteAll()
                return nil
            } else {
                return athletes.first
            }
        }
        return nil
    }
    
    static func find(by uniqueField: Any) -> Athlete? {
        return CoreDataHelper.findOne(entityName, with: "id == %@", arguments: [uniqueField]) as? Athlete
    }
    
    static func retrieveAll() -> [Athlete]? {
        return CoreDataHelper.retrieveAll(name: entityName)
    }
}
