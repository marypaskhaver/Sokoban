//
//  CoreDataManagerTests.swift
//  This HarmonyTests
//
//  Created by Mary Paskhaver on 4/9/21.
//

import XCTest
import CoreData

@testable import This_Harmony

class CoreDataManagerTests: XCTestCase {
    // MARK: - Class vars
    var cdm: CoreDataManager!
    
    lazy var managedObjectModel: NSManagedObjectModel = MockDataModelObjects().managedObjectModel
    lazy var mockPersistentContainer: NSPersistentContainer = MockDataModelObjects().persistentContainer

    var saveNotificationCompleteHandler: ((Notification)->())?

    // MARK: - Set up and tear down methods
    override func setUp() {
        super.setUp()
        cdm = CoreDataManager(container: mockPersistentContainer)
        
        initializeCompletedLevelStubs()
        
        // When a context has an item saved to it, it puts out a notification
        NotificationCenter.default.addObserver(self, selector: #selector(contextSaved(notification:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil )
    }
    
    override func tearDown() {
        flushCompletedLevelData()
        cdm = nil
        super.tearDown()
    }
    
    // MARK: - Initializing + deleting CompletedLevel stubs
    func initializeCompletedLevelStubs() {
        _ = cdm.insertCompletedLevel(lowestSteps: 20)
        cdm.save()
    }
    
    func flushCompletedLevelData() {
       let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CompletedLevel")
       
       let objs = try! mockPersistentContainer.viewContext.fetch(fetchRequest)

       for case let obj as NSManagedObject in objs {
           mockPersistentContainer.viewContext.delete(obj)
       }
       
       try! mockPersistentContainer.viewContext.save()
    }
    
    // MARK: - Testing CompletedLevels
    func testCreatingCompletedLevel() {
        let level = cdm.insertCompletedLevel(lowestSteps: 20)
        XCTAssertNotNil(level)
    }
    
    // MARK: - Context Notification methods
    func contextSaved(notification: Notification ) {
        saveNotificationCompleteHandler?(notification)
    }
        
    func waitForSavedNotification(completeHandler: @escaping ((Notification)->()) ) {
        saveNotificationCompleteHandler = completeHandler
    }
}
