//
//  Task+Convenience.swift
//  Task
//
//  Created by Ian Becker on 7/29/20.
//  Copyright © 2020 Karl Pfister. All rights reserved.
//

import Foundation
import CoreData

extension Task {
    
    convenience init(name: String, notes: String, due: Date, isComplete: Bool = false, context: NSManagedObjectContext = CoreDataStack.context) {
        
        self.init(context: context)
        self.name = name
        self.notes = notes
        self.due = due
    }
}
