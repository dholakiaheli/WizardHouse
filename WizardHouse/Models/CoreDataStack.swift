//
//  CoreDataStack.swift
//  WizardHouse
//
//  Created by Heli Bavishi on 11/12/20.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WizardHouse")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                print(error)
                print(error.localizedDescription)
            }
        }
        return container
    }()
    
    static var context: NSManagedObjectContext {
        return container.viewContext
    }
}

