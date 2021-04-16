//
//  StravaConfigurationProvider.swift
//  VeloToApp
//
//  Created by Максим Газимзянов on 10.04.2021.
//

import Foundation

class StravaConfigurationProvider {
    
    let stravaConfigName = "StravaConfig"
    
    let stravaConfiguration: StravaConfiguration?
    
    static let config = StravaConfigurationProvider()
    
    private init() {
        self.stravaConfiguration = PropertiesReader<StravaConfiguration>.readProperties(stravaConfigName)
    }
    
    func webUrl() -> URL? {
        guard let url = stravaConfiguration?.webUrl else {
            return nil
        }
        return URL(string: url)
    }
    
    func appUrl() -> URL? {
        guard let url = stravaConfiguration?.appUrl else {
            return nil
        }
        return URL(string: url)
    }
    
    func clientId() -> String? {
        guard let clientId = stravaConfiguration?.clientId else {
            return nil
        }
        return clientId
    }
    
    func clientSecret() -> String? {
        guard let clientSecret = stravaConfiguration?.clientSecret else {
            return nil
        }
        return clientSecret
    }
    
    func redirectUrl() -> URL? {
        guard let redirectUrl = stravaConfiguration?.redirectUrl else {
            return nil
        }
        return URL(string: redirectUrl)
    }
    
    func scope() -> String? {
        guard let scope = stravaConfiguration?.scope else {
            return nil
        }
        return scope
    }
    
    func apiUrl() -> URL? {
        guard let apiUrl = stravaConfiguration?.apiUrl else {
            return nil
        }
        return URL(string: apiUrl)
    }
    
    func authUrl() -> URL? {
        guard let authUrl = stravaConfiguration?.authUrl else {
            return nil
        }
        return URL(string: authUrl)
    }
}

struct StravaConfiguration: Codable {
    let webUrl: String
    let appUrl: String
    let clientId: String
    let clientSecret: String
    let redirectUrl: String
    let scope: String
    let apiUrl: String
    let authUrl: String
}
