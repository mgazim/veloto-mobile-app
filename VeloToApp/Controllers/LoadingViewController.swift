//
//  LoadingViewController.swift
//  VeloToApp
//
//  Created by Максим Газимзянов on 17.01.2022.
//

import Foundation
import UIKit
import Gifu

class LoadingViewController: UIViewController {
    
    @IBOutlet weak var loadingGifView: GIFImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingGifView.animate(withGIFNamed: "loading-gif.gif")
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
                                self.performSegue(withIdentifier: SegueIdentifier.fromLoadingToActionCards, sender: self)
                            case .failure(let error):
                                print("Authentication error: \(error.localizedDescription)")
                                Banner.authenticationError()
                                self.performSegue(withIdentifier: SegueIdentifier.fromLoadingToAuthentication, sender: self)
                        }
                    }
                case .failure(let error):
                    // todo: change to proper message
                    print("Authentication error: \(error.localizedDescription)")
                    Banner.authenticationError()
                    self.performSegue(withIdentifier: SegueIdentifier.fromLoadingToAuthentication, sender: self)
            }
        })
    }
    
}
