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

struct OAuthTokenResponse: Decodable {
    let tokenType: String
    let accessToken: String
    let refreshToken: String
    let expiresIn: Int64
    let expiresAt: Int64
    let athlete: SummaryAthlete

    private enum CodingKeys: String, CodingKey {
        case tokenType = "token_type"
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
        case expiresAt = "expires_at"
        case athlete = "athlete"
    }
}

struct OAuthTokenRefreshResponse: Decodable {
    let tokenType: String
    let accessToken: String
    let refreshToken: String
    let expiresIn: Int64
    let expiresAt: Int64

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

struct SummaryAthlete: Decodable {
    let id: Int64
    let firstname: String
    let lastname: String
    let city: String
    let state: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case firstname = "firstname"
        case lastname = "lastname"
        case city = "city"
        case state = "state"
    }
}
