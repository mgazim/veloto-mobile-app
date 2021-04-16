//
//  OAuthToken.swift
//  VeloToApp
//
//  Created by Максим Газимзянов on 11.04.2021.
//

import Foundation

public struct OAuthTokenResponse: Codable {
    let tokenType: String
    let accessToken: String
    let refreshToken: String
    let expiresIn: Int
    let expiresAt: Int
    
    private enum CodingKeys: String, CodingKey {
        case tokenType = "token_type"
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
        case expiresAt = "expires_at"
    }
}
