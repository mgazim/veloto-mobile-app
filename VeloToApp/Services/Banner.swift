//
//  BannerService.swift
//  Veloto
//
//  Created by Максим Газимзянов on 29.01.2022.
//

import Foundation
import UIKit
import NotificationBannerSwift

class Banner {
    
    public static let errorTitle = NSLocalizedString("error_title", comment: "")
    
    public static let unableToAuthorize = NSLocalizedString("unable_to_authoriza", comment: "")
    public static let unableToUpdate = NSLocalizedString("unable_to_update_data", comment: "")
    public static let tryAgainLater = NSLocalizedString("try_again", comment: "")
    
    public static func generalError() {
        let data = BannerData(title: errorTitle, subtitle: tryAgainLater, style: .danger)
        showBanner(data: data)
    }
    
    public static func authenticationError(_ error: Error? = nil) {
        var subtitle = unableToAuthorize
        if let errorMessage = error?.localizedDescription {
            subtitle += ": \(errorMessage)"
        }
        let bannerData = BannerData(title: Banner.errorTitle, subtitle: subtitle, style: .danger)
        showBanner(data: bannerData)
    }

    public static func updateDataError(_ error: Error? = nil) {
        var subtitle = unableToUpdate
        if let errorMessage = error?.localizedDescription {
            subtitle += ": \(errorMessage)"
        }
        let bannerData = BannerData(title: Banner.errorTitle, subtitle: subtitle, style: .danger)
        showBanner(data: bannerData)
    }

    public static func customError(details: String?, error: Error? = nil) {
        var subtitle = "\(details ?? tryAgainLater)"
        if let error = error {
            subtitle += " – \(error.localizedDescription)"
        }
        let bannerData = BannerData(title: Banner.errorTitle, subtitle: subtitle, style: .danger)
        showBanner(data: bannerData)
    }
    
    private static func showBanner(data: BannerData) {
        let banner = FloatingNotificationBanner(title: data.title, subtitle: data.subtitle, leftView: data.leftView, style: data.style)
        banner.backgroundColor = .white
        banner.titleLabel?.textColor = .black
        banner.subtitleLabel?.textColor = .black
        banner.show(cornerRadius: 10, shadowBlurRadius: 15)
    }
    
}

struct BannerData {
    // Mandatory
    let title: String
    let subtitle: String
    let style: BannerStyle
    // Optional
    var leftView: UIView?
}

