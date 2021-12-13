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
    
    @IBOutlet weak var commentTextField: UITextField!

    var actionCard: ActionCard?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .popover
        commentTextField.delegate = self
        
        if let actionCard = actionCard {
            actionCardName.text = actionCard.name
            checkValueField.text = String(actionCard.checkValue / 1000)
            commentTextField.text = actionCard.comment
        } else {
            actionCardName.text = ""
            checkValueField.text = ""
            commentTextField.text = ""
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        switch identifier {
            case "save" where actionCard == nil:
                print("Save new button tapped")
                let newActionCard = ActionCardsCoreDataWrapper.new()
                newActionCard.name = actionCardName.text ?? ""
                let meters = ParseUtils.toInt64(checkValueField.text) * 1000
                newActionCard.checkValue = meters
                newActionCard.left = meters
                newActionCard.comment = commentTextField.text ?? ""
                CoreDataHelper.save()
            case "save" where actionCard != nil:
                print("Editing existing action card")
                actionCard?.name = actionCardName.text ?? ""
                let meters = ParseUtils.toInt64(checkValueField.text) * 1000
                actionCard?.checkValue = meters
                actionCard?.left = meters
                actionCard?.comment = commentTextField.text ?? ""
                CoreDataHelper.save()
            case "close":
                print("Close button tapped")
            default:
                print("Unexpected segue identifier \(identifier)")
        }
    }
    
}

extension ActionCardDetailsViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return self.textLimit(existingText: textField.text, newText: string, limit: 35)
    }
    
    private func textLimit(existingText: String?, newText: String, limit: Int) -> Bool {
        let text = existingText ?? ""
        let isAtLimit = text.count + newText.count <= limit
        return isAtLimit
    }
    
}
