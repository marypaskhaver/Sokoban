//
//  MenuTests.swift
//  This HarmonyTests
//
//  Created by Mary Paskhaver on 5/14/21.
//

import XCTest
import SpriteKit

@testable import This_Harmony

// Also check if SwipeTrackers get disabled

class MenuTests: XCTestCase {
    var gvc: GameViewController!

    override func setUpWithError() throws {
        super.setUp()
        
        CoreDataManager.gameSceneClass = MockDataModelObjects.MockGameScene.self
        gvc = MockDataModelObjects().createGameViewController()
        Floor.defaultTexture = SKTexture(imageNamed: Constants.TileNames.floor.rawValue)
    }
    
    override func tearDownWithError() throws {
        CoreDataManager.gameSceneClass.level = 1
        gvc.gameSceneClass.level = 1 // Resets GameScene or MockGameScene level to default number: 1
        gvc = nil
    }
    
    func testLevelCompleteMenuShowsWhenLevelComplete() {
        let swipeTrackerConstants: MockDataModelObjects.MockConstants = MockDataModelObjects.MockConstants()

        SwipeTracker.constants = swipeTrackerConstants
        Player.constants = swipeTrackerConstants

        gvc.loadLevel(number: 7)
        
        let scene: GameScene = (gvc.view as! SKView).scene as! GameScene
        
        var menuBoxes = scene.children.filter( { $0.name == MenuBox.levelCompleteMenu.rawValue } )
        XCTAssertEqual(menuBoxes.count, 0)

        // Have player push crate down onto only storage space
        let swipeDownTracker: SwipeDownTracker = scene.trackers.filter( { type(of: $0) == SwipeDownTracker.self } )[0] as! SwipeDownTracker
        swipeDownTracker.swipedDown(sender: UISwipeGestureRecognizer())

        menuBoxes = scene.children.filter( { $0.name == MenuBox.levelCompleteMenu.rawValue } )

        XCTAssertEqual(menuBoxes.count, 1)
        XCTAssertTrue(scene.intersects(menuBoxes[0]))
    }
    
    // MARK: - Next Button
    func testNextButtonDisabledWhenLevelComplete() {
        let swipeTrackerConstants: MockDataModelObjects.MockConstants = MockDataModelObjects.MockConstants()

        SwipeTracker.constants = swipeTrackerConstants
        Player.constants = swipeTrackerConstants

        gvc.loadLevel(number: 7)
        
        let scene: GameScene = (gvc.view as! SKView).scene as! GameScene
        
        let nextButton: MSButtonNode = scene.children.first(where: { $0.name == "next_button" }) as! MSButtonNode
        
        XCTAssert(nextButton.state == .active)
        
        let swipeDownTracker: SwipeDownTracker = scene.trackers.filter( { type(of: $0) == SwipeDownTracker.self } )[0] as! SwipeDownTracker
        swipeDownTracker.swipedDown(sender: UISwipeGestureRecognizer())
        
        XCTAssert(nextButton.state == .disabled)
    }
    
    func testNextButtonDisabledWhenLevelPaused() {
        gvc.loadLevel(number: 7)
        
        let scene: GameScene = (gvc.view as! SKView).scene as! GameScene
        
        let nextButton: MSButtonNode = scene.children.first(where: { $0.name == "next_button" }) as! MSButtonNode
        
        XCTAssert(nextButton.state == .active)
        
        let pauseButton: MSButtonNode = scene.children.first(where: { $0.name == "menu_button" }) as! MSButtonNode
        pauseButton.selectedHandler()
        
        XCTAssert(nextButton.state == .disabled)
    }
    
    // MARK: - Prev Button
    func testPrevButtonDisabledWhenLevelComplete() {
        let swipeTrackerConstants: MockDataModelObjects.MockConstants = MockDataModelObjects.MockConstants()

        SwipeTracker.constants = swipeTrackerConstants
        Player.constants = swipeTrackerConstants

        gvc.loadLevel(number: 7)
        
        let scene: GameScene = (gvc.view as! SKView).scene as! GameScene
        
        let prevButton: MSButtonNode = scene.children.first(where: { $0.name == "prev_button" }) as! MSButtonNode
        
        XCTAssert(prevButton.state == .active)
        
        let swipeDownTracker: SwipeDownTracker = scene.trackers.filter( { type(of: $0) == SwipeDownTracker.self } )[0] as! SwipeDownTracker
        swipeDownTracker.swipedDown(sender: UISwipeGestureRecognizer())
        
        XCTAssert(prevButton.state == .disabled)
    }
    
    func testPrevButtonDisabledWhenLevelPaused() {
        gvc.loadLevel(number: 7)
        
        let scene: GameScene = (gvc.view as! SKView).scene as! GameScene
        
        let prevButton: MSButtonNode = scene.children.first(where: { $0.name == "prev_button" }) as! MSButtonNode
        
        XCTAssert(prevButton.state == .active)
        
        let pauseButton: MSButtonNode = scene.children.first(where: { $0.name == "menu_button" }) as! MSButtonNode
        pauseButton.selectedHandler()
        
        XCTAssert(prevButton.state == .disabled)
    }
    
    // MARK: - Reset Button
    func testResetButtonDisabledWhenLevelComplete() {
        let swipeTrackerConstants: MockDataModelObjects.MockConstants = MockDataModelObjects.MockConstants()

        SwipeTracker.constants = swipeTrackerConstants
        Player.constants = swipeTrackerConstants

        gvc.loadLevel(number: 7)
        
        let scene: GameScene = (gvc.view as! SKView).scene as! GameScene
        
        let resetButton: MSButtonNode = scene.children.first(where: { $0.name == "reset_button" }) as! MSButtonNode
        
        XCTAssert(resetButton.state == .active)
        
        let swipeDownTracker: SwipeDownTracker = scene.trackers.filter( { type(of: $0) == SwipeDownTracker.self } )[0] as! SwipeDownTracker
        swipeDownTracker.swipedDown(sender: UISwipeGestureRecognizer())
        
        XCTAssert(resetButton.state == .disabled)
    }
    
    func testResetButtonDisabledWhenLevelPaused() {
        gvc.loadLevel(number: 7)
        
        let scene: GameScene = (gvc.view as! SKView).scene as! GameScene
        
        let resetButton: MSButtonNode = scene.children.first(where: { $0.name == "prev_button" }) as! MSButtonNode
        
        XCTAssert(resetButton.state == .active)
        
        let pauseButton: MSButtonNode = scene.children.first(where: { $0.name == "menu_button" }) as! MSButtonNode
        pauseButton.selectedHandler()
        
        XCTAssert(resetButton.state == .disabled)
    }
    
    // MARK: - Pause Button
    func testPauseButtonDisabledWhenLevelComplete() {
        let swipeTrackerConstants: MockDataModelObjects.MockConstants = MockDataModelObjects.MockConstants()

        SwipeTracker.constants = swipeTrackerConstants
        Player.constants = swipeTrackerConstants

        gvc.loadLevel(number: 7)
        
        let scene: GameScene = (gvc.view as! SKView).scene as! GameScene
        
        let pauseButton: MSButtonNode = scene.children.first(where: { $0.name == "menu_button" }) as! MSButtonNode
        
        XCTAssert(pauseButton.state == .active)
        
        let swipeDownTracker: SwipeDownTracker = scene.trackers.filter( { type(of: $0) == SwipeDownTracker.self } )[0] as! SwipeDownTracker
        swipeDownTracker.swipedDown(sender: UISwipeGestureRecognizer())
        
        XCTAssert(pauseButton.state == .disabled)
    }

}
