//
//  SegueIdentifier.swift
//  Veloto
//
//  Created by Максим Газимзянов on 29.01.2022.
//

import Foundation

struct SegueIdentifier {
    
    public static let fromAuthenticationToLoading = "toLoadingView"
    public static let fromAuthenticationToActionCards = "toActionCards"
    public static let fromLoadingToAuthentication = "toAuthFromLoad"
    public static let fromLoadingToActionCards = "toActionCardsFromLoad"
    public static let fromNavigationToActionCards = "toActionCardsFromNavigation"
    
}
