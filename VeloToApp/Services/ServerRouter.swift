//
//  ServerRouter.swift
//  VeloToApp
//
//  Created by Максим Газимзянов on 22.11.2021.
//

import Foundation
import Alamofire

enum ServerRouter<T: Encodable> {
    
    case create_user(body: T)
    
}

extension ServerRouter: URLRequestConvertible {
    
    fileprivate var requestConfig: (path: String, body: T, method: Alamofire.HTTPMethod) {
        switch self {
            case .create_user(let body):
                return ("/users", body, .post)
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        guard let baseUrl = ServerConfigurationProvider.config.url() else {
            fatalError("No base url for server")
        }
        let config = self.requestConfig
        var urlRequest = URLRequest(url: baseUrl.appendingPathComponent(config.path))
        urlRequest.httpMethod = config.method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder().encode(config.body)
        return try JSONEncoding.default.encode(urlRequest)
    }
    

}
