//
//  ActionCardsTableViewController.swift
//  VeloToApp
//
//  Created by Максим Газимзянов on 20.03.2021.
//

import UIKit

protocol SegueHandler: class {
    func segueToNext(identifier: String)
}

class ActionCardsTableViewController: UITableViewController {
    
    weak var settingsDelegate: SegueHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disabling selection for cells
        let view = self.view as! UITableView
        view.allowsSelection = false
    }
    
    @IBAction func unwindWithSegue(_ segue: UIStoryboardSegue) {
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let settingsAction = UIContextualAction(style: .normal, title: "Настроить") { (action, view, completionHandler) in
            print("Settings clicked")
            self.settingsDelegate!.segueToNext(identifier: "displayActionCardDetails")
            //self.performSegue(withIdentifier: "displayActionCardDetails", sender: action)
            completionHandler(true)
        }
        settingsAction.image = UIImage(systemName: "gear")
        settingsAction.backgroundColor = UIColor(red: 0.965, green: 0.557, blue: 0.322, alpha: 1)
        
        let zeroOutAction = UIContextualAction(style: .normal, title: "Обнулить") { (action, view, completionHandler) in
            print("Zero out clicked")
            completionHandler(true)
        }
        zeroOutAction.image = UIImage(systemName: "checkmark")
        zeroOutAction.backgroundColor = UIColor(red: 0.149, green: 0.427, blue: 0.404, alpha: 1)
        return UISwipeActionsConfiguration(actions: [zeroOutAction, settingsAction])
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { (action, view, completionHandler) in
            print("Delete clicked")
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = UIColor(red: 0.824, green: 0.133, blue: 0.153, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 25
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "actionCardCell", for: indexPath) as! ActionCardTableViewCell
        cell.actionNameLabel.text = "Action text"
        cell.commentLabel.text = "This is a comment for action"
        cell.kmLabel.text = "50 km"
        return cell
    }
    
}
