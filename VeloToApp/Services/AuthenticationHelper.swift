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
    
    static func updateCurrentToken(token: OAuthTokenResponse) {
        // Need to clean up all the tokens first
        CoreDataHelper.deleteAll(of: "OAuthToken")

        let cdToken = CoreDataHelper.new(name: "OAuthToken") as OAuthToken
        cdToken.accessToken = token.accessToken
        cdToken.refreshToken = token.refreshToken
        cdToken.expiresAt = Date(timeIntervalSince1970: Double(token.expiresAt))
        CoreDataHelper.save()
        setOAuthToken(token: cdToken)
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
            CoreDataHelper.delete(entity: toRemove)
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
    
}
