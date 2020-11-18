//
//  Wizard+Convenience.swift
//  WizardHouse
//
//  Created by Heli Bavishi on 11/12/20.
//

import Foundation
import CoreData

extension Wizard {
    convenience init(name: String, house: String, isVisible: Bool = false, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.name = name
        self.house = house
        self.isVisible = isVisible
    }
}
