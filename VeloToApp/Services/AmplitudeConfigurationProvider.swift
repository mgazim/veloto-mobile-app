//
//  AmplitudeConfigurationProvider.swift
//  Veloto
//
//  Created by Максим Газимзянов on 10.07.2022.
//

import Foundation

class AmplitudeConfigurationProvider {

    private let configurationName = "AmplitudeConfig"

    private let amplitudeConfiguration: AmplitudeConfiguration?

    static let config = AmplitudeConfigurationProvider()

    private init() {
        self.amplitudeConfiguration = PropertiesReader<AmplitudeConfiguration>.readProperties(configurationName)
    }

    func apiKey() -> String? {
        guard let apiKey = amplitudeConfiguration?.apiKey else {
            return nil
        }
        return apiKey
    }
    
    func userId() -> String? {
        if let athlete = AthleteCoreDataWrapper.get() {
            return String(athlete.id)
        }
        return nil
    }

}

struct AmplitudeConfiguration: Codable {
    let apiKey: String
}
