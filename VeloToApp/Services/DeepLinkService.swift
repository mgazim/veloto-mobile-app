//
//  DeepLinkService.swift
//  VeloToApp
//
//  Created by Максим Газимзянов on 11.04.2021.
//

import Foundation


class DeepLinkHandler {
    
    typealias DeepLinkCallback = (DeepLink) -> Void
    
    static var handler = DeepLinkHandler()
    
    private init() {}
    
    var deepLinkCallbacks: [DeepLink:DeepLinkCallback] = [:]
    
    func registerCallback(for deepLink: DeepLink, callback: @escaping DeepLinkCallback) {
        deepLinkCallbacks[deepLink] = callback
    }
    
    func handleDeepLinkIfPossible(deepLink: DeepLink) {
        guard let callback = deepLinkCallbacks[deepLink] else {
            print("No callback for deepLink \(deepLink)")
            return
        }
        callback(deepLink)
    }
    
}

struct DeepLinksHolder {
    
    static let authDeepLink: (URL) -> DeepLink = { .Authentication($0) }
    
    // URL to DeepLink map
    static let handlebleDeepLinks: [String: (URL) -> DeepLink] = ["veloto://veloto.com/authentication" : authDeepLink]
    
    static func shouldHandleUrl(_ url: URL) -> DeepLink? {
        let deepLink = handlebleDeepLinks.first(where: {url.absoluteString.hasPrefix($0.key)})?.value
        
        switch deepLink {
            case .some(let urlAsDeepLink):
                return urlAsDeepLink(url)
            default:
                return nil
        }
    }
    
}

enum DeepLink: Hashable {
    
    case Authentication(URL)
    
    init?(url: URL) {
        guard let deepLink = DeepLinksHolder.shouldHandleUrl(url) else {
            return nil
        }
        self = deepLink
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
            case .Authentication:
                hasher.combine(1)
        }
    }
    
    static func ==(l: DeepLink, r: DeepLink) -> Bool {
        return l.hashValue == r.hashValue
    }
}
