//
//  SelectLevelViewControllerTests.swift
//  This HarmonyTests
//
//  Created by Mary Paskhaver on 4/24/21.
//

import XCTest
import SpriteKit

@testable import This_Harmony

class SelectLevelViewControllerTests: XCTestCase {
    var gvc: GameViewController!

    override func setUpWithError() throws {
        super.setUp()
        
        gvc = MockDataModelObjects().createGameViewController()
        Floor.defaultTexture = SKTexture(imageNamed: Constants.TileNames.floor.rawValue)
    }
    
    func createSelectLevelViewController(withConstants constants: MockDataModelObjects.MockConstants = MockDataModelObjects.MockConstants()) -> SelectLevelViewController {
        let slvc: SelectLevelViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SelectLevelViewController") // You initialize it but w/ old constants

        slvc.constants = constants
        slvc.constants.cdm = constants.cdm
               
        slvc.collectionView.layoutIfNeeded()
        
        return slvc
    }
    
    func createLevelAndMoveCrateToFinishIt() {
        let swipeTrackerConstants: MockDataModelObjects.MockConstants = MockDataModelObjects.MockConstants()
        swipeTrackerConstants.cdm = CoreDataManager(container: MockDataModelObjects().persistentContainer)

        SwipeTracker.constants = swipeTrackerConstants
        SwipeTracker.gameSceneClass = MockDataModelObjects.MockGameScene.self

        gvc.loadLevel(number: 7)
        
        let scene: GameScene = (gvc.view as! SKView).scene as! GameScene
        
        // Have player push crate down onto only storage space
        let swipeDownTracker: SwipeDownTracker = scene.trackers.filter( { type(of: $0) == SwipeDownTracker.self } )[0] as! SwipeDownTracker
        swipeDownTracker.swipedDown(sender: UISwipeGestureRecognizer())
    }
    
    func testSelectLevelViewControllerNumberOfCellsEqualsNumberOfLevels() {
        let slvc: SelectLevelViewController = createSelectLevelViewController()
        XCTAssertEqual(slvc.collectionView.visibleCells.count, MockDataModelObjects.MockConstants().numLevels)
    }
    
    func testCompletedLevelsAreAddedToConstants() {
        createLevelAndMoveCrateToFinishIt()

        let slvc: SelectLevelViewController = createSelectLevelViewController(withConstants: SwipeTracker.constants as! MockDataModelObjects.MockConstants)

        XCTAssertTrue(slvc.constants.completeLevels.contains(7))
    }

    func testCompletedLevelsAreCheckmarkedInSelectLevelViewController() {
        createLevelAndMoveCrateToFinishIt()

        let slvc: SelectLevelViewController = createSelectLevelViewController()

        let numCheckedCells = slvc.collectionView.visibleCells.filter { (cell: UICollectionViewCell) in
            if !(cell as! LevelCell).checkmarkView.isHidden {
                print("Active: \((cell as! LevelCell).levelNumberLabel.text)")
            }
            return !(cell as! LevelCell).checkmarkView.isHidden
        }.count

        XCTAssertEqual(slvc.collectionView.visibleCells.count, 12)
        XCTAssertEqual(numCheckedCells, 1)
    }
    
    func testCompletedLevelsStayCheckmarkedWhenGameViewControllerReloads() {
        createLevelAndMoveCrateToFinishIt()

        var slvc: SelectLevelViewController = createSelectLevelViewController()

        let originalNumCheckedCells = slvc.collectionView.visibleCells.filter { (cell: UICollectionViewCell) in
            return !(cell as! LevelCell).checkmarkView.isHidden
        }.count

        XCTAssertEqual(slvc.collectionView.visibleCells.count, 12)
        XCTAssertEqual(originalNumCheckedCells, 1)

        // Reset gvc-- bc CoreData is used, it should have the same data / workings as before
        gvc = MockDataModelObjects().createGameViewController()
        slvc = createSelectLevelViewController()

        let currentNumCheckedCells = slvc.collectionView.visibleCells.filter { (cell: UICollectionViewCell) in
            return !(cell as! LevelCell).checkmarkView.isHidden
        }.count

        XCTAssertEqual(slvc.collectionView.visibleCells.count, 12)
        XCTAssertEqual(currentNumCheckedCells, 1)
    }
    
    func testCellsSplitIntoSectionsBasedOnLevelTheme() {
        let slvc: SelectLevelViewController = createSelectLevelViewController()

        // Since currently all 12 test_levels are listed as Default levels, there should only be one section w/ all 12 test_levels
        XCTAssertEqual(slvc.collectionView.numberOfSections, 1)
        
        // Replace test_level 1's theme from Default to Beach
        slvc.constants.levelThemes[1] = Beach()
        
        slvc.collectionView.reloadData()
        
        XCTAssertEqual(slvc.collectionView.numberOfSections, 2)
    }
    
    func testClickingCellLoadsLevel() {
        XCTAssertNil(gvc.presentedViewController)
        
        // Check if gvc's scene is nil-- it should be, bc nothing has been loaded yet
        var scene: GameScene? = (gvc.view as! SKView).scene as? GameScene
        XCTAssertNil(scene)
        XCTAssertEqual(gvc.gameSceneClass.level, 1) // Default level to load for GameScene

        // Necessary to enable gvc to present SelectLevelViewController in the window hierarchy, as this gvc instance is not seen as a rootViewController by the AppDelegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = gvc
        
        // Show and getSelectLevelViewController
        gvc.presentLevelMenu()
        let slvc = gvc.presentedViewController as! SelectLevelViewController
                
        // Select item
        slvc.collectionView(slvc.collectionView, didSelectItemAt: IndexPath(row: 1, section: 0)) // Level 2
    
        // Check if now, gvc's scene exists
        scene = (gvc.view as! SKView).scene as! GameScene
        
        // Load level normally w/ second gvc
//        let gvc2: GameViewController = MockDataModelObjects().createGameViewController()
//        gvc2.loadLevel(number: 2)
//        let scene2 = (gvc2.view as! SKView).scene as! GameScene
//
//        // Check if level loaded successfully in first gvc by comparing node names to second gvc's nodes
//        for row in 0..<scene!.grid.grid.count {
//            for col in 0..<scene!.grid.grid[row].count {
//                XCTAssertTrue(scene!.grid.grid[row][col].name == scene2.grid.grid[row][col].name)
//            }
//        }
        
        XCTAssertNotNil(scene)
        XCTAssert(gvc.gameSceneClass.level == 2)
    }
}
