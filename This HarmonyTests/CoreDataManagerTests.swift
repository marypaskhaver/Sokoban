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
        
        // Initialize data stubs here
        
        // When a context has an item saved to it, it puts out a notification
        NotificationCenter.default.addObserver(self, selector: #selector(contextSaved(notification:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil )
    }
    
    override func tearDown() {
        // Flush data here
        cdm = nil
        super.tearDown()
    }
    
    // MARK: - Testing creating CompletedLevels
    func initializeCompletedLevelStubs() {
        cdm.insertCompletedLevel(lowestSteps: 20)
        cdm.save()
    }
    
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
