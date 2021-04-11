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
