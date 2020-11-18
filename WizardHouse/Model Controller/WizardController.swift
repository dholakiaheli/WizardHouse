//
//  WizardController.swift
//  WizardHouse
//
//  Created by Heli Bavishi on 11/12/20.
//

import Foundation
import CoreData

class WizardController {
    
    static let shared = WizardController()
    
    //fetched results controller
    let fetchedResultsController: NSFetchedResultsController<Wizard> = {
        
        let fetchRequest: NSFetchRequest<Wizard> = Wizard.fetchRequest()
        let veiledSort = NSSortDescriptor(key: "isVisible", ascending: false)
        fetchRequest.sortDescriptors = [veiledSort]
        
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: "isVisible", cacheName: nil)
    }()
    
    init() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
            print(error.localizedDescription)
        }
    }
    
    //CRUD
    
    func createWizard(name: String, house: String) {
        _ = Wizard(name: name, house: house)
        saveToPersistentStore()
    }
    
    func updateVisibility(wizard: Wizard) {
        wizard.isVisible.toggle()
        saveToPersistentStore()
    }
    
    func deleteWizard(wizard: Wizard) {
        CoreDataStack.context.delete(wizard)
        saveToPersistentStore()
    }
    
    func saveToPersistentStore() {
        do {
            try CoreDataStack.context.save()
        } catch {
            print(error)
            print(error.localizedDescription)
        }
    }
}
