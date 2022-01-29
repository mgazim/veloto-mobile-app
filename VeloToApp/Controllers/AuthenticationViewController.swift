//
//  AuthenticationViewController.swift
//  VeloToApp
//
//  Created by Максим Газимзянов on 20.03.2021.
//

import UIKit
import SafariServices

class AuthenticationViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func unwindWithSegueToAuthentication(_ segue: UIStoryboardSegue) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let athlete = AthleteCoreDataWrapper.get() {
            print("Already authorized with \(athlete), getting up-to-date actions")
            ServerClient.shared.getAllTasksForUser(athlete.id) { (response) in
                switch response {
                    case .success(let result):
                        print("Received tasks \(result)")
                        AthleteTaskCoreDataWrapper.retainAll(of: result.tasks)
                        self.performSegue(withIdentifier: SegueIdentifier.fromAuthenticationToActionCards, sender: self)
                    case .failure(let error):
                        Banner.customError(details: Banner.unableToLoadData, error: error)
                }
            }
        } else {
            print("Need to be authenticated")
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        print("Login button tapped")
        performSegue(withIdentifier: SegueIdentifier.fromAuthenticationToLoading, sender: self)
    }

}
