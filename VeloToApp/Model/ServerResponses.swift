//
//  ServerResponses.swift
//  VeloToApp
//
//  Created by Максим Газимзянов on 23.11.2021.
//

import Foundation

struct CreateUserResponse: Decodable {
    let userId: Int64
    let mileage: Int64
    let tasks: [TaskResponse]
    
    private enum CodingKeys: String, CodingKey {
        case userId = "user"
        case mileage = "mileage"
        case tasks = "tasks"
    }
}

struct TaskResponse: Decodable {
    let name: String
    let every: Int64
    let comment: String?
    
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case every = "every"
        case comment = "comment"
    }
}
