//
//  ServerRequests.swift
//  VeloToApp
//
//  Created by Максим Газимзянов on 17.11.2021.
//

import Foundation

struct CreateUserRequest: Encodable {
    let stravaId: Int
    let accessToken: String
    let refreshToken: String
    let expiresAt: Int
    let apnsToken: String
    
    init(id: Int, accessToken: String, refreshToken: String, expiresAt: Int, apns: String) {
        self.stravaId = id
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
}
