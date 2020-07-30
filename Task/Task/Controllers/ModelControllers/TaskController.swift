//
//  TaskController.swift
//  Task
//
//  Created by Ian Becker on 7/29/20.
//  Copyright © 2020 Karl Pfister. All rights reserved.
//

import Foundation
import CoreData

class TaskController {
    
    var fetchedResultsController: NSFetchedResultsController<Task>
    
    init() {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        let resultsController: NSFetchedResultsController<Task> = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController = resultsController
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("There was an error performing the fetch.")
        }
    }
    
    // Shared Instance
    static let sharedInstance = TaskController()
    
    // CRUD Methods
    
    // Create
    func add(taskWithName name: String, notes: String?, due: Date?) {
        _ = Task(name: name, notes: notes ?? "", due: due ?? Date())
        saveToPersistentStore()
    }
    
    // Update
    func update(task: Task, name: String, notes: String?, due: Date?) {
        task.name = name
        task.notes = notes
        task.due = due
        saveToPersistentStore()
    }
    
    // Delete
    func remove(task: Task) {
        if let moc = task.managedObjectContext {
            moc.delete(task)
            saveToPersistentStore()
        }
    }
    
    func saveToPersistentStore() {
        let moc = CoreDataStack.context
        do {
            try moc.save()
        } catch let saveError {
            print("There was an issue saving: \(saveError)")
        }
    }

    func toggleIsCompleteFor(task: Task) {
        task.isComplete = !task.isComplete
        saveToPersistentStore()
    }
} // End of class
