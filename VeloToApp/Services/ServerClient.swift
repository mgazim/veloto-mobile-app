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
    
    static var shared = ServerClient()
    
    public func createUser(_ data: CreateUserRequest, handler: @escaping CreateUserHandler) {
        do {
            try request(ServerRouter.create_user(body: data))?.responseDecodable(of: CreateUserResponse.self) {
                response in
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
    
}

extension ServerClient {
    fileprivate func request(_ urlRequest: URLRequestConvertible) throws -> DataRequest? {
        return AF.request(urlRequest)
    }
}
