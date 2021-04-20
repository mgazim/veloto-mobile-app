//
//  OAuthCDWrapper.swift
//  VeloToApp
//
//  Created by Максим Газимзянов on 20.04.2021.
//

import Foundation

struct OAuthCoreDataWrapper: CoreDataWrapper {
    
    typealias T = OAuthToken
    
    static let entityName = "OAuthToken"
    
    static func new() -> OAuthToken {
        return CoreDataHelper.new(entityName: entityName) as! OAuthToken
    }
    
    static func delete(entity: OAuthToken) {
        CoreDataHelper.delete(entity: entity)
    }
    
    static func deleteAll() {
        CoreDataHelper.deleteAll(of: entityName)
    }
    
    static func find(by uniqueField: Any) -> OAuthToken? {
        // todo: Use really unique field
        return CoreDataHelper.findOne(entityName, with: "accessToken == %@", arguments: [uniqueField]) as? OAuthToken
    }
    
    static func retrieveAll() -> [OAuthToken]? {
        return CoreDataHelper.retrieveAll(name: entityName)
    }
    
}
