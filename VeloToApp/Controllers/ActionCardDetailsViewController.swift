//
//  ActionCardDetailsViewController.swift
//  VeloToApp
//
//  Created by Максим Газимзянов on 21.03.2021.
//

import UIKit

class ActionCardDetailsViewController: UIViewController {
    
    @IBOutlet weak var actionCardName: UITextField!

    @IBOutlet weak var checkValueField: UITextField!
    
    var actionCard: ActionCard?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .popover

        if let actionCard = actionCard {
            actionCardName.text = actionCard.name
            checkValueField.text = actionCard.checkValue
        } else {
            actionCardName.text = ""
            checkValueField.text = ""
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        switch identifier {
            case "save" where actionCard == nil:
                print("Save new button tapped")
                let newActionCard = ActionCardsCoreDataWrapper.new()
                newActionCard.name = actionCardName.text ?? ""
                newActionCard.checkValue = checkValueField.text ?? "0"
                CoreDataHelper.save()
            case "save" where actionCard != nil:
                print("Editing existing action card")
                actionCard?.name = actionCardName.text ?? ""
                actionCard?.checkValue = checkValueField.text ?? "0"
                CoreDataHelper.save()
            case "close":
                print("Close button tapped")
            default:
                print("Unexpected segue identifier \(identifier)")
        }
    }

}

