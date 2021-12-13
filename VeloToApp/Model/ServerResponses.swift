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
    let name: String
    let every: Int64
    let comment: String?
    
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case every = "every"
        case comment = "comment"
    }
    
    public static func toCore(from task: TaskResponse) -> ActionCard {
        let core = ActionCardsCoreDataWrapper.new()
        core.name = task.name
        core.comment = task.comment
        core.checkValue = task.every
        core.left = task.every
        return core
    }
}

struct DeleteTaskResponse: Decodable {
    let result: String
    
    private enum CodingKeys: String, CodingKey {
        case result = "result"
    }
}
