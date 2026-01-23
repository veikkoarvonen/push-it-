//
//  CoreDataManager.swift
//  Push It!
//
//  Created by Veikko Arvonen on 23.1.2026.
//

import Foundation
import CoreData

final class CoreDataManager {
    
    // MARK: - Singleton
    static let shared = CoreDataManager()
    
    // MARK: - Properties
    let container: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        container.viewContext
    }
    
    // MARK: - Init
    init(modelName: String = "Push_It_") {
        // IMPORTANT: Replace "YourModelName" with the .xcdatamodeld filename (without extension)
        container = NSPersistentContainer(name: modelName)
        
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        
        // Recommended defaults
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func saveContext() {
        let context = viewContext
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            print("Core Data save error: \(error)")
        }
    }
    
    //MARK: - Create workout
    func createWorkout(reps: Int16, date: Date) {
        let workout = Workout(context: viewContext)
        workout.reps = reps
        workout.date = date
        saveContext()
    }
    
    //MARK: - Fetch workouts
    func fetchAllWorkouts() -> [Workout] {
        let request: NSFetchRequest<Workout> = Workout.fetchRequest()
        
        do {
            return try viewContext.fetch(request)
        } catch {
            print("Fetch all workouts error: \(error)")
            return []
        }
    }
    
}
