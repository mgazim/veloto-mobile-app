//
//  LoadingViewController.swift
//  VeloToApp
//
//  Created by Максим Газимзянов on 17.01.2022.
//

import Foundation
import UIKit

class LoadingViewController: UIViewController {
    
    override func viewDidLoad() {
        print("Authorizing...")
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
                                self.performSegue(withIdentifier: "toActionCardsFromLoad", sender: self)
                            case .failure(let error):
                                print(error)
                                self.showError(title: "Authentication failed", message: error.localizedDescription)
                                self.performSegue(withIdentifier: "toAuthenticationFromLoad", sender: self)
                        }
                    }
                case .failure(let error):
                    // todo: change to proper message
                    print("Authentication error: \(error.localizedDescription)")
                    self.showError(title: "Authentication failed", message: error.localizedDescription)
                    self.performSegue(withIdentifier: "toAuthenticationFromLoad", sender: self)
            }
        })
    }
    
    fileprivate func showError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
}
