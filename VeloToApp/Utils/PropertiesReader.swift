//
//  PropertiesReader.swift
//  VeloToApp
//
//  Created by Максим Газимзянов on 10.04.2021.
//

import Foundation

struct PropertiesReader<Type: Codable> {
    
    static func readProperties(_ fileName: String) -> Type? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "plist"),
              let xml = FileManager.default.contents(atPath: path) else { return nil }
        let properties = try? PropertyListDecoder().decode(Type.self, from: xml)
        return properties
    }
    
}
