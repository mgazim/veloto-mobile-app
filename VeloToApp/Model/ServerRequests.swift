//
//  ServerRequests.swift
//  VeloToApp
//
//  Created by Максим Газимзянов on 17.11.2021.
//

import Foundation

struct CreateUserRequest: Encodable {
    let stravaId: Int64
    let accessToken: String
    let refreshToken: String
    let expiresAt: Int64
    let apnsToken: String
    
    private init(stravaId: Int64, accessToken: String, refreshToken: String, expiresAt: Int64, apns: String) {
        self.stravaId = stravaId
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.expiresAt = expiresAt
        self.apnsToken = apns
    }
    
    private enum CodingKeys: String, CodingKey {
        case stravaId = "strava_id"
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresAt = "access_expires_at"
        case apnsToken = "apns_token"
    }
    
    public static func of(_ token: OAuthTokenResponse) -> CreateUserRequest {
        return CreateUserRequest(stravaId: token.athlete.id, accessToken: token.accessToken, refreshToken: token.refreshToken, expiresAt: token.expiresAt, apns: "apns_token")
    }
}

struct CreateTaskRequest: Encodable {
    let name: String
    let every: Int64
    let comment: String?
    
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case every = "every"
        case comment = "comment"
    }
}
