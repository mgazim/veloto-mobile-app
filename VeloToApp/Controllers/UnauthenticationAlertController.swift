//
//  UnauthenticationAlertController.swift
//  VeloToApp
//
//  Created by Максим Газимзянов on 30.03.2021.
//

import UIKit

class UnauthenticationAlertController: UIViewController {
    
    let tokenDelegate = CoreDataTokenDelegate()
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        print("Logout tapped")
        performSegue(withIdentifier: "logout", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Preparing \(segue)")
        guard let identifier = segue.identifier else { return }
        switch identifier {
            case "logout":
                print("Logout segue")
                if let token = tokenDelegate.get() {
                    CoreDataHelper.delete(entity: token)
                    print("Removed token")
                } else {
                    print("Error: noting to remove!")
                }
            default:
                print("Unknown identifier")
        }
    }
}
