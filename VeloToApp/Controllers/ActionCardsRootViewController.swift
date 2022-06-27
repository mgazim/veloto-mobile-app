//
//  ActionCardsRootViewController.swift
//  VeloToApp
//
//  Created by Максим Газимзянов on 28.03.2021.
//

import UIKit

class ActionCardsRootViewController: UIViewController, ModalViewControllerDelegate {
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func viewDidLoad() {
        updateDistanceView()
    }
    
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
                if var controller = segue.destination as? ModalViewController {
                    controller.masterDelegate = self
                }
            default:
                print("Unknown identifier")
        }
    }

    func updateInModalViewController(_ sender: ModalViewController) {
        updateDistanceView()
    }

    private func updateDistanceView() {
        if let athlete = AthleteCoreDataWrapper.get() {
            // TODO: Get rid of Russian
            let overallDistance = athlete.overallDistance / 1000
            if overallDistance > 0 {
                distanceLabel.text = "Пробег – \(overallDistance) км"
            } else {
                distanceLabel.text = "Нет данных по пробегу"
            }
        }
    }

}
