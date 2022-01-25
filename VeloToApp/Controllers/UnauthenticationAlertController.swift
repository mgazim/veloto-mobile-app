//
//  UnauthenticationAlertController.swift
//  VeloToApp
//
//  Created by Максим Газимзянов on 30.03.2021.
//

import UIKit

class UnauthenticationAlertController: UIViewController {

    @IBAction func logoutButtonTapped(_ sender: Any) {
        print("Logout tapped")
        //Authentication.deauthorize()
        AthleteCoreDataWrapper.deleteAll()
        AthleteTaskCoreDataWrapper.deleteAll()
        performSegue(withIdentifier: "logout", sender: self)
    }

}
