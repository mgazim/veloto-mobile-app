//
//  ActionCardsTableViewController.swift
//  VeloToApp
//
//  Created by Максим Газимзянов on 20.03.2021.
//

import UIKit
import SwiftUI

class ActionCardsTableViewController: UITableViewController, ModalViewController {

    var masterDelegate: ModalViewControllerDelegate?
    
    var selectedRow: Int?
    
    var athleteTasks = [AthleteTask]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: Add activity indicator here
        self.athleteTasks = self.getActionCardsForCurrentAthlete()
        athleteTasks.sort(by: { ($0.every - $0.remain) < ($1.every - $1.remain) })
        // Disabling selection for cells
        let view = self.view as! UITableView
        view.allowsSelection = false

        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: NSNotification.Name(SceneDelegate.ReloadNotification), object: nil)
    }

    @objc func refresh(_ sender: AnyObject) {
        refreshData()
        self.refreshControl?.endRefreshing()
    }

    @objc private func refreshData() {
        guard let athlete = AthleteCoreDataWrapper.get() else {
            return
        }
        ServerClient.shared.getAthorizedUserData(athlete.id) { (response) in
            switch response {
                case .success(let result):
                    print("Received update \(result)")
                    AthleteTaskCoreDataWrapper.retainAll(of: result.tasks)
                    AthleteCoreDataWrapper.updateDistance(result.distance, for: athlete)
                    self.updateTableRows()
                    self.masterDelegate?.updateInModalViewController(self)
                case .failure(let error):
                    print("Error getting up-to-date user data: \(error.localizedDescription)")
                    Banner.customError(details: "Не могу обновить данные", error: error)
            }
        }
    }
    
    @IBAction func unwindWithSegue(_ segue: UIStoryboardSegue) {
        updateTableRows()
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "") { (action, view, completionHandler) in
            print("Edit clicked")
            self.selectedRow = indexPath.row
            self.performSegue(withIdentifier: "edit", sender: action)
            completionHandler(true)
        }
        editAction.image = UIImage(systemName: "gear")
        editAction.backgroundColor = UIColor(red: 0.965, green: 0.557, blue: 0.322, alpha: 1)
        
        let zeroOutAction = UIContextualAction(style: .normal, title: "") { (action, view, completionHandler) in
            print("Zero out clicked")
            let toZeroOut = self.athleteTasks[indexPath.row]
            let athlete = AthleteCoreDataWrapper.get()!
            ServerClient.shared.cleanRemainForTask(userId: athlete.id, taskId: toZeroOut.id) { (result) in
                switch result {
                    case .success(_):
                        AthleteTaskCoreDataWrapper.cleanRemain(toZeroOut)
                        AmplitudeService.shared.resetTask(taskId: toZeroOut.id)
                        self.updateTableRows()
                    case .failure(let error):
                        print("Error zeroing-out: \(error.localizedDescription)")
                        Banner.generalError()
                }
            }
            completionHandler(true)
        }
        zeroOutAction.image = UIImage(systemName: "checkmark")
        zeroOutAction.backgroundColor = UIColor(red: 0.149, green: 0.427, blue: 0.404, alpha: 1)
        return UISwipeActionsConfiguration(actions: [zeroOutAction, editAction])
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "") { (action, view, completionHandler) in
            print("Delete clicked")
            let toRemove = self.athleteTasks[indexPath.row]
            let athlete = AthleteCoreDataWrapper.get()!
            ServerClient.shared.deleteTaskOfUser(userId: athlete.id, taskId: toRemove.id) { (result) in
                switch result {
                    case .success(_):
                        let removedId = toRemove.id
                        AthleteTaskCoreDataWrapper.deleteById(removedId)
                        AmplitudeService.shared.deleteTask(taskId: removedId)
                        self.athleteTasks = self.getActionCardsForCurrentAthlete()
                        self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    case .failure(let error):
                        print("Error removing: \(error.localizedDescription)")
                        Banner.generalError()
                }
            }
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = UIColor(red: 0.824, green: 0.133, blue: 0.153, alpha: 1)
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return athleteTasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "actionCardCell", for: indexPath) as! ActionCardTableViewCell
        let task = athleteTasks[indexPath.row]
        cell.actionNameLabel.text = task.name
        cell.commentLabel.text = task.comment
        let kmRemain = VelotoUtils.calculateRemainKmForTask(task)
        if kmRemain > 0 {
            cell.kmLabel.text = "\(kmRemain)"
            cell.kmLabel.textColor = .label
        } else {
            cell.kmLabel.text = "ТО"
            cell.kmLabel.textColor = .systemRed
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if var controller = segue.destination as? ModalViewController {
            controller.masterDelegate = self
        }
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
                let actionCard = athleteTasks[index]
                let destination = segue.destination as! ActionCardDetailsViewController
                destination.athleteTask = actionCard
            case "addActionCard":
                print("Create action card button tapped")
            default:
                print("Unexpected segue identifier \(identifier)")
        }
    }
    
    private func getActionCardsForCurrentAthlete() -> [AthleteTask] {
        if AthleteCoreDataWrapper.get() != nil {
            return AthleteTaskCoreDataWrapper.retrieveAll() ?? []
        } else {
            // TODO: Unwind to authentication page
            print("Error: No authenticated athlete")
            return []
        }
    }
    
    fileprivate func updateTableRows() {
        athleteTasks = self.getActionCardsForCurrentAthlete()
        athleteTasks.sort(by: { ($0.every - $0.remain) < ($1.every - $1.remain) })
        UIView.transition(with: tableView, duration: 0.25, options: .transitionCrossDissolve, animations: { self.tableView.reloadData() }, completion: nil)
    }
    
}

extension ActionCardsTableViewController: ModalViewControllerDelegate {
    func updateInModalViewController(_ sender: ModalViewController) {
        updateTableRows()
    }
}
