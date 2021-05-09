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

}
