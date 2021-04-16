//
//  Router.swift
//  StravaSwift
//
//  Created by Matthew on 11/11/2015.
//  Copyright © 2015 Matthew Clarkson. All rights reserved.
//
//  Changed by Maksim Gazimzyanov on 12.04.2021.
//

import Foundation
import Alamofire

enum Router {
    
    case token(code: String)
    
}

extension Router: URLRequestConvertible {
    
    func asURLRequest() throws -> URLRequest {
        let config = self.requestConfig
        var base = StravaConfigurationProvider.config.apiUrl()!

        var urlRequest = URLRequest(url: base.appendingPathComponent(config.path))
        urlRequest.httpMethod = config.method.rawValue
        
        /*if let token = StravaClient.sharedInstance.token?.accessToken {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }*/
        
        if let params = config.params, params.count > 0 {
            switch config.method {
                case .get:
                    var urlComponents = URLComponents(url: urlRequest.url!, resolvingAgainstBaseURL: false)!
                    urlComponents.queryItems = params.map { URLQueryItem(name: $0, value: "\($1)")}
                    urlRequest.url = urlComponents.url!
                    return urlRequest
                default:
                    return try JSONEncoding.default.encode(urlRequest, with: params)
            }
        } else {
            return try JSONEncoding.default.encode(urlRequest)
        }
    }
    
    fileprivate var requestConfig: (path: String, params: Dictionary<String, Any>?, method: Alamofire.HTTPMethod) {
        switch self {
            case .token(let code):
                return ("/oauth/token", buildTokenParameters(code), .post)
        }
    }
    
    private func buildTokenParameters(_ code: String) -> [String: Any]  {
        return [
            "client_id" : StravaConfigurationProvider.config.clientId() ?? 0,
            "client_secret" : StravaConfigurationProvider.config.clientSecret() ?? "",
            "code" : code
        ]
    }
}
