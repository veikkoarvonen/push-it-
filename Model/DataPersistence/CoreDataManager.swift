

import CoreData
import UIKit

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
//MARK: - Create
    func createWorkout(reps: Int16, date: Date) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let workout = Workout(context: managedContext)
        workout.reps = reps
        workout.date = date
        
        do {
            try managedContext.save()
            print("Data saved: \(reps) reps on \(date)")
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        
    }
    
//MARK: - Read
    func fetchAllWorkouts() -> [Workout] {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<Workout> = Workout.fetchRequest()
        
        do {
            return try managedContext.fetch(request)
        } catch {
            print("Fetch all workouts error: \(error)")
            return []
        }
    }
    
    func fetchWorkouts(from startDate: Date, to endDate: Date) -> [Workout] {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<Workout> = Workout.fetchRequest()
        request.predicate = NSPredicate(
            format: "%K >= %@ AND %K < %@",
            #keyPath(Workout.date), startDate as NSDate,
            #keyPath(Workout.date), endDate as NSDate
        )
        request.sortDescriptors = [
            NSSortDescriptor(key: #keyPath(Workout.date), ascending: true)
        ]

        do {
            return try managedContext.fetch(request)
        } catch {
            print("Fetch workouts range error:", error)
            return []
        }
    }
    
    func fetchSingleDayWorkouts(for date: Date) -> [Workout] {
        let cal = Calendar.current
        let timeRangeStart = cal.startOfDay(for: date)
        let nextDay = cal.date(byAdding: .day, value: 1, to: date)!
        let timeRangeEnd = cal.startOfDay(for: nextDay)
        let workouts = fetchWorkouts(from: timeRangeStart, to: timeRangeEnd)
        return workouts
    }
    
    func logAllWorkouts() {
        let workouts = fetchAllWorkouts()
        for workout in workouts {
            print("Reps: \(workout.reps), Date: \(workout.date ?? Date())")
        }
    }
    
    // MARK: - Delete
    func deleteAllWorkouts() {

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext

        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Workout.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            try context.save()
            print("All workouts deleted")
        } catch {
            print("Failed to delete workouts:", error)
        }
    }

    
    
    
}
