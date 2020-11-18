//
//  WizardTableViewController.swift
//  WizardHouse
//
//  Created by Heli Bavishi on 11/12/20.
//

import UIKit
import CoreData

class WizardTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        WizardController.shared.fetchedResultsController.delegate = self
    }

    @IBAction func createWizardButtonTapped(_ sender: Any) {
        presentAlertController()
    }
    
    func presentAlertController() {
        let alertController = UIAlertController(title: "Add a Wizard", message: "Which house shall they join", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter wizard's name..."
            
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter wizard's house..."
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let wizardName = alertController.textFields?[0].text,
                  let wizardHouse = alertController.textFields?[1].text else { return }
            WizardController.shared.createWizard(name: wizardName, house: wizardHouse)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        
        present(alertController, animated: true)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return WizardController.shared.fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WizardController.shared.fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 7
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if WizardController.shared.fetchedResultsController.sectionIndexTitles[section] == "0" {
            return "Invisible"
        }else {
            return "Visible"
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "wizardCell", for: indexPath) as? WizardTableViewCell else { return UITableViewCell() }

        let wizardToDisplay = WizardController.shared.fetchedResultsController.object(at: indexPath)
        cell.wizard = wizardToDisplay
        cell.delegate = self
        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let wizardToDelete = WizardController.shared.fetchedResultsController.object(at: indexPath)
            WizardController.shared.deleteWizard(wizard: wizardToDelete)
            //tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
extension WizardTableViewController: WizardCellDelegate {
    func houseButtonTapped(_ sender: WizardTableViewCell) {
        
        guard let indexPath = tableView.indexPath(for: sender) else { return }
        let wizard = WizardController.shared.fetchedResultsController.object(at: indexPath)
        WizardController.shared.updateVisibility(wizard: wizard)
        sender.updateViews()
    }
}
extension WizardTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            let indexSet = IndexSet(integer: sectionIndex)
            tableView.insertSections(indexSet, with: .automatic)
        case .delete:
            let indexSet = IndexSet(integer: sectionIndex)
            tableView.deleteSections(indexSet, with: .automatic)
        case .move:
            break
        case .update:
            break
        @unknown default:
            fatalError()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { break }
            tableView.insertRows(at: [newIndexPath], with: .fade)
        case .delete:
            guard let indexPath = indexPath else { break }
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { break }
            tableView.moveRow(at: indexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else { break }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        @unknown default:
            fatalError()
        }
    }
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
}
