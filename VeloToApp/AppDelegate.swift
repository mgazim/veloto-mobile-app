//
//  AppDelegate.swift
//  VeloToApp
//
//  Created by Максим Газимзянов on 20.03.2021.
//

import UIKit
import Amplitude

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Initializing Amplitude
        if let apiKey = AmplitudeConfigurationProvider.config.apiKey() {
            // Enable sending automatic session events
            Amplitude.instance().trackingSessionEvents = true
            // Initialize SDK
            Amplitude.instance().initializeApiKey(apiKey)
            // Set userId
            // TODO: Rethink?
            let userId = AmplitudeConfigurationProvider.config.userId() ?? "UNAUTHORIZED"
            print("Using Amplitude userId: \(userId)")
            Amplitude.instance().setUserId(userId)
            // Log an event
            Amplitude.instance().logEvent("app_start")
        } else {
            print("Unable to init Amplitude as apiKey is missing")
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

