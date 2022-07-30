//
//  ActionCardDetailsViewController.swift
//  VeloToApp
//
//  Created by Максим Газимзянов on 21.03.2021.
//

import UIKit

class ActionCardDetailsViewController: UIViewController, ModalViewController {
    
    var masterDelegate: ModalViewControllerDelegate?
    
    @IBOutlet weak var actionCardName: UITextField!
    
    @IBOutlet weak var checkValueField: UITextField!
    
    @IBOutlet weak var commentTextField: UITextField!

    var athleteTask: AthleteTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: .keyboardWillShow, name: UIResponder.keyboardWillShowNotification, object: self.view.window)
        NotificationCenter.default.addObserver(self, selector: .keyboardWillHide, name: UIResponder.keyboardWillHideNotification, object: self.view.window)
        
        self.modalPresentationStyle = .popover
        actionCardName.delegate = self
        checkValueField.delegate = self
        checkValueField.addDoneCancelToolbar(onDone: (target: self, action: .tapDone))
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
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: self.view.window)
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
                            // TODO: Ask server to return whole object on create
                            AthleteTaskCoreDataWrapper.persistNew(id: id, name: name, every: meters, remain: 0, comment: comment)
                            AmplitudeService.shared.createTask(taskId: id)
                            self.masterDelegate?.updateInModalViewController(self)
                        case .failure(let error):
                            print("Error saving task: \(error)")
                            Banner.generalError()
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
                            CoreDataHelper.save()
                            AmplitudeService.shared.editTask(taskId: self.athleteTask!.id)
                            self.masterDelegate?.updateInModalViewController(self)
                        case .failure(let error):
                            print("Error: \(error.localizedDescription)")
                            Banner.generalError()
                    }
                }
            case "close":
                print("Close button tapped")
            default:
                print("Unexpected segue identifier \(identifier)")
        }
    }

    @objc fileprivate func keyboardWillShow(notification: NSNotification) {
        let userInfo: [AnyHashable : Any] = notification.userInfo!
        if let keyboardSize = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc fileprivate func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc fileprivate func checkValueFieldDoneButtonTapped() {
        checkValueField.resignFirstResponder()
    }

}

private extension UITextField {
    func addDoneCancelToolbar(onDone: (target: Any, action: Selector)? = nil) {
        let onDone = onDone ?? (target: self, action: .doneButtonTapped)
        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            // TODO: Fix Russian
            UIBarButtonItem(title: "Готово", style: .done, target: onDone.target, action: onDone.action)
        ]
        toolbar.sizeToFit()
        self.inputAccessoryView = toolbar
    }
}

private extension Selector {
    static let tapDone = #selector(ActionCardDetailsViewController.checkValueFieldDoneButtonTapped)
    static let doneButtonTapped = #selector(ActionCardDetailsViewController.checkValueFieldDoneButtonTapped)
    static let keyboardWillShow = #selector(ActionCardDetailsViewController.keyboardWillShow(notification:))
    static let keyboardWillHide = #selector(ActionCardDetailsViewController.keyboardWillHide(notification:))
}

extension ActionCardDetailsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// TODO: investigate and add limits
class TextLimitDelegate: NSObject, UITextViewDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return self.textLimit(existingText: textField.text, newText: string, limit: 35)
    }
    
    private func textLimit(existingText: String?, newText: String, limit: Int) -> Bool {
        let text = existingText ?? ""
        let isAtLimit = text.count + newText.count <= limit
        return isAtLimit
    }
}
