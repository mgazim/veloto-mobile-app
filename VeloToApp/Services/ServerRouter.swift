//
//  ServerRouter.swift
//  VeloToApp
//
//  Created by Максим Газимзянов on 22.11.2021.
//

import Foundation
import Alamofire

enum ServerRouter<T: Encodable> {
    
    case create_user(body: CreateUserRequest)
    
    case all_tasks(_ userId: Int64)
    
    case user_data(_ userId: Int64)
    
    case create_task(userId: Int64, body: CreateTaskRequest)
    
    case delete_task(userId: Int64, taskId: Int64)
    
    case update_task(userId: Int64, taskId: Int64, body: CreateTaskRequest)
    
    case clean_remain(userId: Int64, taskId: Int64)

}

// TODO: Remove it when you know how to code properly...
struct Dummy: Encodable {}

extension ServerRouter : URLRequestConvertible {
    fileprivate var requestConfig: (path: String, body: Encodable?, params: [String: Any]?, method: Alamofire.HTTPMethod) {
        switch self {
            case .create_user(let body):
                return ("/users", body, nil, .post)
            case .all_tasks(let userId):
                return ("/tasks", nil, ["user_id" : userId], .get)
            case .user_data(let userId):
                return ("/athlete", nil, ["user_id" : userId], .get)
            case .create_task(let userId, let body):
                return ("/tasks", body, ["user_id" : userId], .post)
            case .delete_task(let userId, let taskId):
                return ("/tasks/\(taskId)", nil, ["user_id" : userId], .delete)
            case .update_task(let userId, let taskId, let body):
                return ("/tasks/\(taskId)", body, ["user_id" : userId], .put)
            case .clean_remain(let userId, let taskId):
                return ("/tasks/\(taskId)/remain", nil, ["user_id" : userId], .patch)
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        guard let baseUrl = ServerConfigurationProvider.config.url() else {
            fatalError("No base url for server")
        }
        let config = self.requestConfig
        var components = URLComponents(url: baseUrl.appendingPathComponent(config.path), resolvingAgainstBaseURL: false)!
        if let params = config.params {
            components.queryItems = params.map { (key, value) in
                URLQueryItem(name: key, value: String(describing: value))
            }
        }
        var urlRequest = URLRequest(url: components.url!)
        urlRequest.httpMethod = config.method.rawValue
        if let body = config.body {
            urlRequest.httpBody = try JSONEncoder().encode(body as! T)
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        return urlRequest
    }
    

}
