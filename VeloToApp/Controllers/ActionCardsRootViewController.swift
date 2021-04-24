//
//  ActionCardsRootViewController.swift
//  VeloToApp
//
//  Created by Максим Газимзянов on 28.03.2021.
//

import UIKit

class ActionCardsRootViewController: UIViewController {
    
    func segueToNext(identifier: String) {
        self.performSegue(withIdentifier: identifier, sender: self)
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        if identifier == "embedActionCardsTable" {
            print("embedActionCardsTable in action!")
        }
    }
    
}
