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
    
    // TODO: Get rid of Russian!
    public static let errorTitle = "Ошибка"
    
    public static let unableToLoadData = "Мы не смогли обновить данные с сервера"
    public static let unableToUpdataData = "Мы не смогли обновить данные на сервере"
    
    
    public static func generalError() {
        let data = BannerData(title: errorTitle, subtitle: "Попробуйте позже", style: .danger)
        showBanner(data: data)
    }
    
    public static func authenticationError(_ error: Error) {
        let bannerData = BannerData(title: Banner.errorTitle, subtitle: "Мы не смогли авторизировать вас сейчас – попробуйте позже: \(error.localizedDescription)", style: .danger)
        showBanner(data: bannerData)
    }
    
    public static func customError(details: String?, error: Error?) {
        var subtitle = "\(details ?? "Попробуйте позже")"
        if let error = error {
            subtitle += " – \(error.localizedDescription)"
        }
        let bannerData = BannerData(title: Banner.errorTitle, subtitle: subtitle, style: .danger)
        showBanner(data: bannerData)
    }
    
    public static func showBanner(data: BannerData) {
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

