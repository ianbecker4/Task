//
//  TaskListTableViewController.swift
//  Task
//
//  Created by Ian Becker on 7/29/20.
//  Copyright © 2020 Karl Pfister. All rights reserved.


import UIKit
import CoreData

class TaskListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        TaskController.sharedInstance.fetchedResultsController.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        tableView.reloadData()
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return TaskController.sharedInstance.fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TaskController.sharedInstance.fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as? ButtonTableViewCell else {return UITableViewCell()}

        let task = TaskController.sharedInstance.fetchedResultsController.object(at: indexPath)
        
        cell.update(withTask: task)

        cell.delegate = self

        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let taskToDelete = TaskController.sharedInstance.fetchedResultsController.object(at: indexPath)
            TaskController.sharedInstance.remove(task: taskToDelete)
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let sectionNumber = Int(TaskController.sharedInstance.fetchedResultsController.sections?[section].name ?? "Zero")
        if sectionNumber == 0 {
            return "Complete"
        } else {
            return "Incomplete"
        }
        
//        return TaskController.sharedInstance.fetchedResultsController.sections?[section].name ?? "0"
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
            let destinationVC = segue.destination as? TaskDetailTableViewController else {return}
            let task = TaskController.sharedInstance.fetchedResultsController.object(at: indexPath)
            destinationVC.task = task
        }
    }
}

extension TaskListTableViewController: ButtonTableViewCellDelegate {
    func buttonCellButtonTapped(_ sender: ButtonTableViewCell) {
        guard let indexPath = tableView.indexPath(for: sender) else {return}
        let task = TaskController.sharedInstance.fetchedResultsController.object(at: indexPath)
        TaskController.sharedInstance.toggleIsCompleteFor(task: task)
        tableView.reloadData()
    }
}

extension TaskListTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            guard let indexPath = indexPath else {break}
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .insert:
            guard let newIndexPath = newIndexPath else {break}
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else {break}
            tableView.moveRow(at: indexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else {break}
            tableView.reloadRows(at: [indexPath], with: .automatic)
        @unknown default:
            fatalError()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            let indexSet = IndexSet(integer: sectionIndex)
            tableView.insertSections(indexSet, with: .automatic)
        case .delete:
            let indexSet = IndexSet(integer: sectionIndex)
            tableView.deleteSections(indexSet, with: .automatic)
        default:
            fatalError()
        }
//        switch type {
//        case .delete:
//            let sectionIndex = sectionIndex
//            tableView.deleteSections([sectionIndex], with: .automatic)
//        case .insert:
//            let newSectionIndex = sectionIndex
//            tableView.insertSections([newSectionIndex], with: .automatic)
//        case .move:
//            let newSectionIndex = sectionIndex
//            tableView.moveSection(sectionIndex, toSection: newSectionIndex)
//        case .update:
//            let sectionIndex = sectionIndex
//            tableView.reloadSections([sectionIndex], with: .automatic)
//        @unknown default:
//            fatalError()
//        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
