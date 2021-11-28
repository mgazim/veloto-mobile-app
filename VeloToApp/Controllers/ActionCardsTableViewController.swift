//
//  ActionCardsTableViewController.swift
//  VeloToApp
//
//  Created by Максим Газимзянов on 20.03.2021.
//

import UIKit

class ActionCardsTableViewController: UITableViewController {
    
    var selectedRow: Int?
    
    var actionCards = [ActionCard]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.actionCards = self.getActionCardsForCurrentAthlete()
        // Disabling selection for cells
        let view = self.view as! UITableView
        view.allowsSelection = false
    }
    
    @IBAction func unwindWithSegue(_ segue: UIStoryboardSegue) {
        self.actionCards = self.getActionCardsForCurrentAthlete()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Настроить") { (action, view, completionHandler) in
            print("Edit clicked")
            self.selectedRow = indexPath.row
            self.performSegue(withIdentifier: "edit", sender: action)
            completionHandler(true)
        }
        editAction.image = UIImage(systemName: "gear")
        editAction.backgroundColor = UIColor(red: 0.965, green: 0.557, blue: 0.322, alpha: 1)
        
        let zeroOutAction = UIContextualAction(style: .normal, title: "Обнулить") { (action, view, completionHandler) in
            print("Zero out clicked")
            completionHandler(true)
        }
        zeroOutAction.image = UIImage(systemName: "checkmark")
        zeroOutAction.backgroundColor = UIColor(red: 0.149, green: 0.427, blue: 0.404, alpha: 1)
        return UISwipeActionsConfiguration(actions: [zeroOutAction, editAction])
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { (action, view, completionHandler) in
            print("Delete clicked")
            let toRemove = self.actionCards[indexPath.row]
            ActionCardsCoreDataWrapper.delete(entity: toRemove)
            self.actionCards = self.getActionCardsForCurrentAthlete()
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = UIColor(red: 0.824, green: 0.133, blue: 0.153, alpha: 1)
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actionCards.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "actionCardCell", for: indexPath) as! ActionCardTableViewCell
        
        let actionCard = actionCards[indexPath.row]
        cell.actionNameLabel.text = actionCard.name
        cell.commentLabel.text = actionCard.comment
        // todo : get rid of Russian!
        let kmLeft = actionCard.left / 1000
        cell.kmLabel.text = "\(kmLeft) км"
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        switch identifier {
            case "edit":
                print("Edit action card tapped")
                guard let index = self.selectedRow else {
                    print("Error: No row to edit!")
                    return
                }
                let actionCard = actionCards[index]
                let destination = segue.destination as! ActionCardDetailsViewController
                destination.actionCard = actionCard
            case "addActionCard":
                print("Create action card button tapped")
            default:
                print("Unexpected segue identifier \(identifier)")
        }
    }
    
    private func getActionCardsForCurrentAthlete() -> [ActionCard] {
        if let currentAthlete = AthleteCoreDataWrapper.get() {
            return ActionCardsCoreDataWrapper.retrieveAllForAthleteID(id: currentAthlete.id) ?? []
        } else {
            print("Error: No authenticated athlete to get cards for")
            return []
        }
    }
    
}
