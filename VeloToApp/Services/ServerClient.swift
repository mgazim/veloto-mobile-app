//
//  ServerClient.swift
//  VeloToApp
//
//  Created by Максим Газимзянов on 17.11.2021.
//

import Foundation
import Alamofire

class ServerClient {
    
    public typealias CreateUserHandler = (Result<CreateUserResponse, Swift.Error>) -> ()
    public typealias GetAuthUserData = (Result<UserDataResponse, Swift.Error>) -> ()
    public typealias CreateTaskHandler = (Result<TaskResponse, Swift.Error>) -> ()
    public typealias DeleteTaskHandler = (Result<DeleteTaskResponse, Swift.Error>) -> ()
    public typealias UpdateTaskHandler = (Result<TaskResponse, Swift.Error>) -> ()
    public typealias CleanRemainForTaskHandler = (Result<CleanTaskResponse, Swift.Error>) -> ()

    static var shared = ServerClient()
    
    public func createUser(_ data: CreateUserRequest, handler: @escaping CreateUserHandler) {
        do {
            try request(ServerRouter<CreateUserRequest>.create_user(body: data))?.responseDecodable(of: CreateUserResponse.self) { response in
                switch response.result {
                    case .success(let dataResponse):
                        handler(.success(dataResponse))
                    case .failure(let error):
                        handler(.failure(error))
                }
            }
        } catch let error as NSError {
            handler(.failure(error))
        }
    }
    
    public func getAthorizedUserData(_ userId: Int64, handler: @escaping GetAuthUserData) {
        do {
            try request(ServerRouter<Dummy>.user_data(userId))?.responseDecodable(of: UserDataResponse.self) {
                responce in
                switch responce.result {
                    case .success(let dataResponse):
                        
                        handler(.success(dataResponse))
                    case .failure(let error):
                        handler(.failure(error))
                }
            }
        } catch let error as NSError {
            handler(.failure(error))
        }
    }

    public func createTaskOfUser(userId id: Int64, body: CreateTaskRequest, handler: @escaping CreateTaskHandler) {
        do {
            try request(ServerRouter<CreateTaskRequest>.create_task(userId: id, body: body))?.responseDecodable(of: TaskResponse.self) { response in
                switch response.result {
                    case .success(let dataResponse):
                        handler(.success(dataResponse))
                    case .failure(let error):
                        handler(.failure(error))
                }
            }
        } catch let error as NSError {
            handler(.failure(error))
        }
    }
    
    public func deleteTaskOfUser(userId: Int64, taskId: Int64, handler: @escaping DeleteTaskHandler) {
        do {
            try request(ServerRouter<Dummy>.delete_task(userId: userId, taskId: taskId))?.responseDecodable(of: DeleteTaskResponse.self) { response in
                switch response.result {
                    case .success(let result):
                        handler(.success(result))
                    case .failure(let error):
                        handler(.failure(error))
                }
            }
        } catch let error as NSError {
            handler(.failure(error))
        }
    }
    
    public func updateTaskOfUser(userId: Int64, taskId: Int64, body: CreateTaskRequest, handler: @escaping UpdateTaskHandler) {
        do {
            try request(ServerRouter<CreateTaskRequest>.update_task(userId: userId, taskId: taskId, body: body))?.responseDecodable(of: TaskResponse.self) { response in
                switch response.result {
                    case .success(let result):
                        handler(.success(result))
                    case .failure(let error):
                        handler(.failure(error))
                }
            }
        } catch let error as NSError {
            handler(.failure(error))
        }
    }
    
    public func cleanRemainForTask(userId: Int64, taskId: Int64, handler: @escaping CleanRemainForTaskHandler) {
        do {
            try request(ServerRouter<Dummy>.clean_remain(userId: userId, taskId: taskId))?.responseDecodable(of: CleanTaskResponse.self) { response in
                switch response.result {
                    case .success(let result):
                        handler(.success(result))
                    case .failure(let error):
                        handler(.failure(error))
                }
            }
        } catch let error as NSError {
            handler(.failure(error))
        }
    }
    
}

extension ServerClient {
    fileprivate func request(_ urlRequest: URLRequestConvertible) throws -> DataRequest? {
        return AF.request(urlRequest)
    }
}
