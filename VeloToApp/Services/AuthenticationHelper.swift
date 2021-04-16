//
//  AuthenticationHolder.swift
//  VeloToApp
//
//  Created by Максим Газимзянов on 16.04.2021.
//

import Foundation

public typealias Authentication = AuthenticationHelper

public struct AuthenticationHelper {
    
    // Current token
    static var token: String? {
        if let accessToken = refresh() {
            return accessToken
        } else {
            return nil
        }
    }
    
    private static var _oauthToken: OAuthToken?
    
    private static func setOAuthToken(token: OAuthToken?) {
        _oauthToken = token
    }
    
    static func set(token: OAuthTokenResponse) {
        let cdToken = CoreDataHelper.new(name: "OAuthToken") as OAuthToken
        cdToken.accessToken = token.accessToken
        cdToken.refreshToken = token.refreshToken
        //cdToken.expiresAt = token?.expiresAt
        CoreDataHelper.save()
        setOAuthToken(token: cdToken)
    }

    static func unauthenticate() {
        if let token = _oauthToken {
            CoreDataHelper.delete(entity: token)
            setOAuthToken(token: nil)
            print("Token cleared up")
        } else {
            print("Error: no token!")
        }
    }

}

extension AuthenticationHelper {
    
    private static func get() -> OAuthToken? {
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
    
    private static func refresh() -> String? {
        if _oauthToken == nil {
            if let cdToken = get() {
                _oauthToken = cdToken
            } else {
                _oauthToken = nil
            }
        }
        // todo: add refreshing
        return _oauthToken?.accessToken
    }
    
}
