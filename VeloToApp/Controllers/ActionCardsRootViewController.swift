//
//  ActionCardsRootViewController.swift
//  VeloToApp
//
//  Created by Максим Газимзянов on 28.03.2021.
//

import UIKit

class ActionCardsRootViewController: UIViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        switch identifier {
            case "addActionCard":
                print("In add action")
                if var controller = segue.destination as? ModalViewController {
                    let tableViewController = self.children.first(where: { $0 is ActionCardsTableViewController }) as! ModalViewControllerDelegate
                    controller.masterDelegate = tableViewController
                }
            case "embedActionCardsTable":
                print("embedActionCardsTable in action!")
            default:
                print("Unknown identifier")
        }
    }

}
