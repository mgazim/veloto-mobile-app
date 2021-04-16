//
//  CoreDataTokenDelegate.swift
//  VeloToApp
//
//  Created by Максим Газимзянов on 14.04.2021.
//

import Foundation

struct CoreDataTokenDelegate: TokenDelegate {
    
    func get() -> OAuthToken? {
        guard let objects = CoreDataHelper.retrieveAll(name: "OAuthToken"),
              !objects.isEmpty else {
            print("No authentication token")
            return nil
        }
        if objects.count > 1 {
            // todo: check for this inconsistency
        }
        return objects[0] as? OAuthToken
    }
    
    func set(_ token: OAuthTokenResponse?) {
        let cdToken = CoreDataHelper.new(name: "OAuthToken") as OAuthToken
        cdToken.accessToken = token?.accessToken
        cdToken.refreshToken = token?.refreshToken
        //cdToken.expiresAt = token?.expiresAt
        CoreDataHelper.save()
    }

}
