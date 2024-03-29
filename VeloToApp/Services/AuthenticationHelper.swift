//
//  AuthenticationHolder.swift
//  VeloToApp
//
//  Created by Максим Газимзянов on 16.04.2021.
//

import Foundation

/*public typealias Authentication = AuthenticationHelper

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
    
    static func athlete() -> Athlete? {
        guard let token = _oauthToken else {
            print("No OAuthToken instance!")
            return nil
        }
        return token.athlete
    }

    static func updateCurrentToken(token: OAuthTokenResponse) {
        // Need to clean up all the tokens first
        OAuthCoreDataWrapper.deleteAll()

        let cdToken = OAuthCoreDataWrapper.new()
        cdToken.accessToken = token.accessToken
        cdToken.refreshToken = token.refreshToken
        cdToken.expiresAt = Date(timeIntervalSince1970: Double(token.expiresAt))

        if let athlete = AthleteCoreDataWrapper.find(by: token.athlete.id) {
            print("Athelte [\(token.athlete.id)] already exists: \(athlete)")
            athlete.token = cdToken
        } else {
            let athlete = AthleteCoreDataWrapper.new()
            athlete.id = Int32(token.athlete.id)
            athlete.firstname = token.athlete.firstname
            athlete.lastname = token.athlete.lastname
            athlete.token = cdToken
            print("New athlet created: \(athlete)")
        }

        CoreDataHelper.save()
        setOAuthToken(token: cdToken)
    }
    
    static func updateCurrentToken(token: OAuthTokenRefreshResponse) {
        if let athlete = athlete() {
            if let currentToken = athlete.token {
                print("Removing current token for [athlete:\(athlete.id)]: \(token)")
                OAuthCoreDataWrapper.delete(entity: currentToken)
            } else {
                print("Not token for [athlete:\(athlete.id)]")
            }
            let cdToken = OAuthCoreDataWrapper.new()
            cdToken.accessToken = token.accessToken
            cdToken.refreshToken = token.refreshToken
            cdToken.expiresAt = Date(timeIntervalSince1970: Double(token.expiresAt))
            cdToken.athlete = athlete
            
            CoreDataHelper.save()
            setOAuthToken(token: cdToken)
        } else {
            // Should never happen
            OAuthCoreDataWrapper.deleteAll()
            fatalError("No Athlete found during refreshing!")
        }
    }
    
    static func deauthorize() {
        if let toRemove = _oauthToken {
            let accessToken = token ?? ""
            print("Deauthenticating: \(accessToken)")
            StravaClient.client.request(Router.deauthorize(accessToken: accessToken),
                success: { (response: DeauthorizeResponse?) in
                    print("Deauthorized successfully: \(response?.accessToken ?? "empty")")
                }, failure: { (error: NSError) in
                    print("Error: cannot deauthorize")
                    debugPrint("\(error)")
                }
            )
            OAuthCoreDataWrapper.delete(entity: toRemove)
            setOAuthToken(token: nil)
            print("Token cleared up")
        } else {
            print("Error: no token!")
        }
    }
    
}

extension AuthenticationHelper {

    private static func refresh() -> String? {
        if _oauthToken == nil {
            if let cdToken = OAuthCoreDataWrapper.currentToken() {
                setOAuthToken(token: cdToken)
                if (_oauthToken?.expiresAt)! < Date() {
                    StravaClient.client.refreshAccessToken((_oauthToken?.refreshToken)!) {
                        result in
                        switch result {
                            case .success(let tokenResponse):
                                Authentication.updateCurrentToken(token: tokenResponse)
                                print("Refreshed token successfully")
                            case .failure(let error):
                                // todo: handle properly
                                print("Error: cannot refresh: \(error.localizedDescription)")
                        }
                    }
                }
            } else {
                _oauthToken = nil
            }
        }
        return _oauthToken?.accessToken
    }
    
}*/
