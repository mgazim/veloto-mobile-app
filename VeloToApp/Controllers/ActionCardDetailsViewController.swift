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

    var athleteTask: AthleteTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .popover
        commentTextField.delegate = self
        if let actionCard = athleteTask {
            actionCardName.text = actionCard.name
            checkValueField.text = String(actionCard.every / 1000)
            commentTextField.text = actionCard.comment
        } else {
            actionCardName.text = ""
            checkValueField.text = ""
            commentTextField.text = ""
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        let athlete = AthleteCoreDataWrapper.get()!
        switch identifier {
            case "save" where athleteTask == nil:
                print("Save new button tapped")
                let name = actionCardName.text ?? ""
                let comment = commentTextField.text ?? ""
                let meters = ParseUtils.toInt64(checkValueField.text) * 1000
                let payload = CreateTaskRequest(name: name, every: meters, comment: comment)
                ServerClient.shared.createTaskOfUser(userId: athlete.id, body: payload) { (result) in
                    switch result {
                        case .success(let response):
                            let id = response.id
                            print("Created new task with id \(id)")
                            AthleteTaskCoreDataWrapper.persistNew(id: id, name: name, every: meters, remain: meters, comment: comment)
                        case .failure(let error):
                            // TODO: Show alert!
                            print("Error saving task: \(error)")
                    }
                }
            case "save" where athleteTask != nil:
                print("Editing existing athlete task")
                let name = actionCardName.text ?? ""
                let every = ParseUtils.toInt64(checkValueField.text) * 1000
                let comment = commentTextField.text ?? ""
                let request = CreateTaskRequest(name: name, every: every, comment: comment)
                ServerClient.shared.updateTaskOfUser(userId: athlete.id, taskId: athleteTask!.id, body: request) { (result) in
                    switch result {
                        case .success(_):
                            self.athleteTask?.name = name
                            // TODO: Cover case when remain > every after update
                            self.athleteTask?.every = every
                            self.athleteTask?.comment = comment
                            // TODO: Make auto-updatable
                            CoreDataHelper.save()
                        case .failure(let error):
                            print("Error: \(error.localizedDescription)")
                    }
                }
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
