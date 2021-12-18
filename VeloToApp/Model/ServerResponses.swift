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

struct TasksResponse: Decodable {
    let tasks: [TaskResponse]
    
    private enum CodingKeys: String, CodingKey {
        case tasks = "tasks"
    }
}

struct CreateTaskResponse: Decodable {
    let id: Int64
    
    private enum CodingKeys: String, CodingKey {
        case id = "task"
    }
}

struct TaskResponse: Decodable {
    let id: Int64
    let name: String
    let every: Int64
    let remain: Int64
    let comment: String?
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case every = "every"
        case remain = "remain"
        case comment = "comment"
    }
}

struct DeleteTaskResponse: Decodable {
    let result: String
    
    private enum CodingKeys: String, CodingKey {
        case result = "result"
    }
}
