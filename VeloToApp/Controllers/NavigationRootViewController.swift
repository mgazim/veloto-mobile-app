//
//  NavigationRootViewController.swift
//  Veloto
//
//  Created by Максим Газимзянов on 11.07.2022.
//

import Foundation
import UIKit

class NavigationRootViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let athlete = AthleteCoreDataWrapper.get() {
            print("Already authorized with \(athlete), getting up-to-date actions")
            ServerClient.shared.getAthorizedUserData(athlete.id) { (response) in
                switch response {
                    case .success(let result):
                        print("Received tasks \(result)")
                        AthleteTaskCoreDataWrapper.retainAll(of: result.tasks)
                        AthleteCoreDataWrapper.updateDistance(result.distance, for: athlete)
                    case .failure(let error):
                        print("Error getting up-to-date user data: \(error.localizedDescription)")
                        AthleteCoreDataWrapper.deleteAll()
                        AthleteTaskCoreDataWrapper.deleteAll()
                        Banner.generalError()
                }
                self.performSegue(withIdentifier: SegueIdentifier.fromAuthenticationToActionCards, sender: self)
            }
        } else {
            print("Need to be authenticated")
        }
    }
    
}
