//
//  ServerConfigurationProvider.swift
//  VeloToApp
//
//  Created by Максим Газимзянов on 17.11.2021.
//

import Foundation

class ServerConfigurationProvider {
    
    let configurationName = "ServerConfig"
    
    let serverConfiguration: ServerConfiguration?
    
    static let config = ServerConfigurationProvider()
    
    private init() {
        self.serverConfiguration = PropertiesReader<ServerConfiguration>.readProperties(configurationName)
    }
    
    func url() -> URL? {
        guard let schema = serverConfiguration?.schema,
              let address = serverConfiguration?.address,
              let rootPath = serverConfiguration?.rootPath
        else {
            return nil
        }
        return URL(string: "\(schema)://\(address)\(rootPath)")
    }
    
}

struct ServerConfiguration: Codable {
    let schema: String
    let address: String
    let port: String
    let rootPath: String
}
