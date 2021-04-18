//
//  StravaResponses.swift
//  VeloToApp
//
//  Created by Максим Газимзянов on 18.04.2021.
//

import Foundation

struct Error: Decodable {
    let code: String
    let field: String
    let resource: String
}

struct Fault: Decodable {
    let message: String
    let errors: [Error]
}

struct OAuthTokenResponse: Codable {
    let tokenType: String
    let accessToken: String
    let refreshToken: String
    let expiresIn: Int
    let expiresAt: Int
    // todo: Add Athlete info

    private enum CodingKeys: String, CodingKey {
        case tokenType = "token_type"
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
        case expiresAt = "expires_at"
    }
}

struct DeauthorizeResponse: Decodable {
    let accessToken: String
    
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}
