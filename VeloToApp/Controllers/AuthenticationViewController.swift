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
        if let token = Authentication.token {
            print("Already authorized with \(token)")
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
                    print("Authenticated successfully: \(token)")
                    self.performSegue(withIdentifier: "toActionCards", sender: self)
                case .failure(let error):
                    print("Authentication error: \(error.localizedDescription)")
                    let alert = UIAlertController(title: "Error",
                                                  message: error.localizedDescription,
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true)
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Preparing \(segue)")
        guard let identifier = segue.identifier else { return }
        print("Id: \(identifier)")
    }
}
