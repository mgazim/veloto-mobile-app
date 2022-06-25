//
//  StravaClient.swift
//  StravaSwift
//
//  Created by Matthew on 11/11/2015.
//  Copyright © 2015 Matthew Clarkson. All rights reserved.
//
//  Changed by Maksim Gazimzyanov on 11.04.2021.
//

import Foundation
import SafariServices
import AuthenticationServices
import Alamofire

class StravaClient: NSObject {
    
    public typealias AuthorizationHandler = (Result<OAuthTokenResponse, Swift.Error>) -> ()
    public typealias RefreshHandler = (Result<OAuthTokenRefreshResponse, Swift.Error>) -> ()
    
    // Shared instance
    static var client = StravaClient()
    
    private let configuration: StravaConfigurationProvider
    private var currentAuthorizationHandler: AuthorizationHandler?
    private var authSession: ASWebAuthenticationSession?
    
    private let state: String
    
    override private init() {
        configuration = StravaConfigurationProvider.config
        state = UUID().uuidString
    }
    
}

extension StravaClient: ASWebAuthenticationPresentationContextProviding {
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return ASPresentationAnchor()
    }
    
    public func authorize(resultHandler: @escaping AuthorizationHandler) {
        guard let appUrl = buildAppAuthenticationUrl(), let webUrl = buildWebAuthenticationUrl() else {
            fatalError("Error: cannot build authentication url")
        }
        if UIApplication.shared.canOpenURL(appUrl) {
            print("Using Strava app")
            currentAuthorizationHandler = resultHandler
            UIApplication.shared.open(appUrl, options: [:])
        } else {
            print("Using ASWebAuthSession: \(webUrl)")
            authSession = ASWebAuthenticationSession(url: webUrl, callbackURLScheme: configuration.callbackScheme()) { (url, error) in
                if let url = url, error == nil {
                    print("Received redirectUrl: \(url)")
                    self.handleAuthorizationRedirect(url, handler: resultHandler)
                } else {
                    print("Unable to authenticate")
                    resultHandler(.failure(error!))
                }
            }
            authSession?.presentationContextProvider = self
            authSession?.prefersEphemeralWebBrowserSession = true
            authSession?.start()
        }
    }
    
    public func handleAuthorizationRedirect(_ url: URL) {
        self.handleAuthorizationRedirect(url) { result in
            if let currentAuthorizationHandler = self.currentAuthorizationHandler {
                currentAuthorizationHandler(result)
                self.currentAuthorizationHandler = nil
            }
        }
    }
    
    private func handleAuthorizationRedirect(_ url: URL, handler: @escaping AuthorizationHandler) {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        if !checkScopes(of: components) {
            // TODO: Add banner!
            print("No required scopes!")
            handler(.failure(generateError(failureReason: "No required scopes", code: .noScopes)))
        } else {
            if let code = components?.queryItems?.first(where: { $0.name == "code" })?.value {
                self.exchangeForToken(code, handler: handler)
            } else {
                handler(.failure(generateError(failureReason: "Invalid authorization code", response: nil)))
            }
        }
    }
    
    private func checkScopes(of components: URLComponents?) -> Bool {
        guard let components = components else { return false }
        if let scopes = components.queryItems?.first(where: { $0.name == "scope" })?.value {
            let required = Set(configuration.scope()?.split(separator: ",") ?? [])
            let received = Set(scopes.split(separator: ","))
            return required.isSubset(of: received)
        } else {
            print("No scopes provided!")
            return false
        }
    }
    
    private func exchangeForToken(_ code: String, handler: @escaping AuthorizationHandler) {
        do {
            try oauthRequest(Router.token(code: code))?.responseDecodable(of: OAuthTokenResponse.self) { response in
                switch response.result {
                    case .success(let token):
                        handler(.success(token))
                    case .failure(let error):
                        handler(.failure(error))
                }
            }
        } catch let error as NSError {
            handler(.failure(error))
        }
    }
    
    public func refreshAccessToken(_ refreshToken: String, handler: @escaping RefreshHandler) {
        do {
            try oauthRequest(Router.refresh(refreshToken: refreshToken))?.responseDecodable(of: OAuthTokenRefreshResponse.self) { response in
                switch response.result {
                    case .success(let token):
                        handler(.success(token))
                    case .failure(let error):
                        handler(.failure(error))
                }
            }
        } catch let error as NSError {
            handler(.failure(error))
        }
    }
    
    public func request<T: Decodable>(_ route: Router, success: @escaping (((T)?) -> Void), failure: @escaping (NSError) -> Void) {
        do {
            try oauthRequest(route)?.responseDecodable(of: T.self) { response in
                // HTTP Status codes above 400 are errors
                if let statusCode = response.response?.statusCode, (400..<500).contains(statusCode) {
                    failure(self.generateError(failureReason: "Strava API Error", response: response.response))
                } else {
                    switch response.result {
                        case .success(let decodable):
                            success(decodable)
                        case .failure(let error):
                            failure(self.generateError(cause: error))
                    }
                }
            }
        } catch let error as NSError {
            failure(error)
        }
    }
    
}

extension StravaClient {
    
    fileprivate func oauthRequest(_ urlRequest: URLRequestConvertible) throws -> DataRequest? {
        return AF.request(urlRequest)
    }
    
}

// MARK: private util functions

extension StravaClient {
    
    private func buildAppAuthenticationUrl() -> URL? {
        guard let url = configuration.appUrl(),
              let clientId = configuration.clientId(),
              let callbackScheme = configuration.callbackScheme(),
              let redirectAddress = configuration.redirectAddress(),
              let scope = configuration.scope() else {
            return nil
        }
        let authUrl = "\(url.absoluteString)?client_id=\(clientId)&redirect_uri=\(callbackScheme)://\(redirectAddress)&response_type=code&scope=\(scope)&state=\(state)"
        return URL(string: authUrl)
    }
    
    private func buildWebAuthenticationUrl() -> URL? {
        guard let url = configuration.webUrl(),
              let clientId = configuration.clientId(),
              let callbackScheme = configuration.callbackScheme(),
              let redirectAddress = configuration.redirectAddress(),
              let scope = configuration.scope() else {
            return nil
        }
        let authUrl = "\(url.absoluteString)?client_id=\(clientId)&redirect_uri=\(callbackScheme)://\(redirectAddress)&response_type=code&scope=\(scope)&state=\(state)"
        return URL(string: authUrl)
    }
    
    public enum ErrorCode: Int {
        case noScopes = 1
        
        func parse(from: Int) -> ErrorCode? {
            if from == ErrorCode.noScopes.rawValue {
                return .noScopes
            }
            return nil
        }
    }
    
    private func generateError(failureReason: String, code: ErrorCode?) -> NSError {
        let errorDomain = "io.velotoapp"
        let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
        let returnError = NSError(domain: errorDomain, code: code?.rawValue ?? 0, userInfo: userInfo)
        return returnError
    }
    
    private func generateError(failureReason: String, response: HTTPURLResponse?) -> NSError {
        let errorDomain = "io.velotoapp"
        let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
        let code = response?.statusCode ?? 0
        let returnError = NSError(domain: errorDomain, code: code, userInfo: userInfo)
        return returnError
    }
    
    private func generateError(cause: AFError) -> NSError {
        let errorDomain = "io.velotoapp"
        let userInfo = [NSLocalizedFailureReasonErrorKey: cause.failureReason ?? "Unknown reason"]
        let code = cause.responseCode ?? 0
        let returnError = NSError(domain: errorDomain, code: code, userInfo: userInfo)
        return returnError
    }
    
}
