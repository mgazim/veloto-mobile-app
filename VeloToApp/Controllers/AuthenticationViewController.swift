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
                        self.performSegue(withIdentifier: "toActionCards", sender: self)
                    case .failure(let error):
                        self.showError(title: "Updating Tasks", message: "Error: \(error.localizedDescription)")
                }
            }
        } else {
            print("Need to be authenticated")
        }
    }
    
    // TODO: Think of the User flow here
    @IBAction func loginButtonTapped(_ sender: Any) {
        print("Login button tapped")
        StravaClient.client.authorize(resultHandler: { (result) in
            switch result {
                case .success(let token):
                    print("Authenticated successfully")
                    let serverRequest = CreateUserRequest.of(token)
                    print("CreateUserRequest: \(serverRequest)")
                    ServerClient.shared.createUser(serverRequest) { (result) in
                        switch result {
                            case .success(let athlete):
                                print(athlete)
                                AthleteCoreDataWrapper.persistNew(from: athlete, with: token.athlete.id)
                                AthleteTaskCoreDataWrapper.persistAll(of: athlete.tasks)
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
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}
