//
//  AmplitudeService.swift
//  Veloto
//
//  Created by Максим Газимзянов on 13.07.2022.
//

import Foundation
import Amplitude

class AmplitudeService {
    
    static var shared = AmplitudeService()
    
    public func initialize() {
        // Initializing Amplitude
        if let apiKey = AmplitudeConfigurationProvider.config.apiKey() {
            // Enable sending automatic session events
            Amplitude.instance().trackingSessionEvents = true
            // TODO: Rethink?
            let userId = AmplitudeConfigurationProvider.config.userId() ?? "UNAUTHORIZED"
            print("Using Amplitude userId: \(userId)")
            // Initialize SDK with a user Id
            Amplitude.instance().initializeApiKey(apiKey, userId: userId)
        } else {
            print("Unable to init Amplitude as apiKey is missing")
        }
    }
    
    public func setUserId() {
        let userId = AmplitudeConfigurationProvider.config.userId() ?? "UNAUTHORIZED"
        print("Using Amplitude userId: \(userId)")
        Amplitude.instance().setUserId(userId)
    }

    //MARK: Authorization
    public func login() {
        log(event: .log_in)
    }

    public func logout() {
        log(event: .log_out)
    }

    //MARK: Tasks
    public func createTask(taskId: Int64) {
        log(event: .create_task, properties: ["id" : taskId])
    }
    
    public func deleteTask(taskId: Int64) {
        log(event: .delete_task, properties: ["id" : taskId])
    }
    
    public func editTask(taskId: Int64) {
        log(event: .edit_task, properties: ["id" : taskId])
    }
    
    public func resetTask(taskId: Int64) {
        log(event: .reset_task, properties: ["id" : taskId])
    }
    
    public func taskMaintenance(taskId: Int64) {
        log(event: .notification, properties: ["id" : taskId])
    }
    
    private func log(event: Event, properties: [String:Any] = [:]) {
        if properties.isEmpty {
            Amplitude.instance().logEvent(event.rawValue)
        } else {
            Amplitude.instance().logEvent(event.rawValue, withEventProperties: properties)
        }
    }
    
}

// TODO: Use associated values?
enum Event: String {    
    // Authorization
    case log_in = "log_in"
    case log_out = "log_out"
    // Tasks
    case create_task = "create_task"
    case delete_task = "delete_task"
    case edit_task = "edit_task"
    case reset_task = "reset_task" // zero-out
    case notification = "notification" // need maintenance
}
