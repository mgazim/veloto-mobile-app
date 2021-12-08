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
            performSegue(withIdentifier: "toActionCards", sender: self)
        } else {
            print("Need to be authenticated")
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        print("Login button tapped")
        StravaClient.client.authorize(resultHandler: { (result) in
            switch result {
                case .success(let token):
                    print("Authenticated successfully: \(token), sending to server")
                    let serverRequest = CreateUserRequest(stravaId: token.athlete.id, accessToken: token.accessToken, refreshToken: token.refreshToken, expiresAt: token.expiresAt, apns: "apns_token")
                    ServerClient.shared.createUser(serverRequest) { result in
                        switch result {
                            case .success(let athlete):
                                print(athlete)
                                let coreAthlete = AthleteCoreDataWrapper.new()
                                coreAthlete.id = athlete.userId
                                coreAthlete.stravaId = token.athlete.id
                                coreAthlete.overallDistance = athlete.mileage
                                CoreDataHelper.save()
                                for task in athlete.tasks {
                                    let coreTask = ActionCardsCoreDataWrapper.new()
                                    coreTask.athlete = coreAthlete
                                    coreTask.name = task.name
                                    coreTask.comment = task.comment
                                    coreTask.checkValue = task.every
                                    coreTask.left = task.every
                                }
                                CoreDataHelper.save()
                                self.performSegue(withIdentifier: "toActionCards", sender: self)
                            case .failure(let error):
                                print(error)
                                self.showError(title: "Authentication failed", message: error.localizedDescription)
                        }
                    }
                case .failure(let error):
                    // todo: change to proper message
                    print("Authentication error: \(error.localizedDescription)")
                    self.showError(title: "Authentication failed", message: error.localizedDescription)
            }
        })
    }

}

extension AuthenticationViewController {
    fileprivate func showError(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}
