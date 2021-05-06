//
//  CoreDataManager.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 4/9/21.
//

import CoreData
import UIKit

class CoreDataManager {
    let persistentContainer: NSPersistentContainer!
    
    // MARK: - Init with dependency
    init(container: NSPersistentContainer) {
        self.persistentContainer = container
        self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    convenience init() {
        //Use the default container for production environment
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Can not get shared app delegate")
        }
        
        self.init(container: appDelegate.persistentContainer)
    }
    
    // Commit changes in the background thread instead of main thread
    lazy var backgroundContext: NSManagedObjectContext = {
        return self.persistentContainer.newBackgroundContext()
    }()
    
    // MARK: - Adding data
    func insertCompletedLevel(levelNumber num: Int32, lowestSteps: Int32) -> CompletedLevel? {
        guard let level = NSEntityDescription.insertNewObject(forEntityName: "CompletedLevel", into: backgroundContext) as? CompletedLevel else { return nil }
        
        level.levelNumber = num
        level.lowestSteps = lowestSteps
        
        return level
    }
    
    // MARK: - Retrieving data
    func fetchCompletedLevelWithLowestSteps(with request: NSFetchRequest<CompletedLevel> = CompletedLevel.fetchRequest()) -> CompletedLevel {
        // What about levelNumber?
        let request: NSFetchRequest<CompletedLevel> = CompletedLevel.fetchRequest()
        request.predicate = NSPredicate(format: "levelNumber = %d", GameScene.level)
        request.sortDescriptors = [NSSortDescriptor(key: "lowestSteps", ascending: true)]
        request.fetchLimit = 1

        let results = try? persistentContainer.viewContext.fetch(request)

        // No previous CompletedLevels have ever been saved or the default data contains 0 steps-- no level can be completed w/ 0 steps
        if (results?.count == 0 || (results?.count == 1 && results?[0].lowestSteps == 0)) {
            print("create")
            let newCompletedLevel = self.insertCompletedLevel(levelNumber: Int32(GameScene.level), lowestSteps: Int32.max)!
            self.save()
            return newCompletedLevel
        }
        
        return (results?[0])!
    }
    
    func fetchAllCompletedLevelsInAscendingOrderAndLowestSteps() -> [CompletedLevel] {
        let request: NSFetchRequest<CompletedLevel> = CompletedLevel.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "lowestSteps", ascending: true)]

        let results = try? persistentContainer.viewContext.fetch(request)
        
        return (results?.count ?? 0) > 0 ? results! : []
    }
    
    // MARK: - Removing data
    func deleteAllData(forEntityNamed name: String, fromViewContext managedContext: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext) {

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                managedContext.delete(objectData)
            }
            
            print("Deleted \(name) data")
            
        } catch let error {
            print("Delete all data in \(name) error :", error)
        }
        
    }
    
    // MARK: - Universal save
    func save() {
        if backgroundContext.hasChanges {
            do {
                try backgroundContext.save()
            } catch {
                print("Save error \(error)")
            }
        }

    }
}
