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
    
    func createSelectLevelViewController(withConstants constants: Constants = MockDataModelObjects.MockConstants()) -> SelectLevelViewController {
        let slvc: SelectLevelViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SelectLevelViewController")
        slvc.constants = constants
        slvc.collectionView.layoutIfNeeded()
        
        return slvc
    }
    
    func testSelectLevelViewControllerNumberOfCellsEqualsNumberOfLevels() {
        let slvc: SelectLevelViewController = createSelectLevelViewController()
        XCTAssertEqual(slvc.collectionView.visibleCells.count, MockDataModelObjects.MockConstants().numLevels)
    }
    
    func testCompletedLevelsAreAddedToConstants() {
        SwipeTracker.constants = MockDataModelObjects.MockConstants()
        SwipeTracker.gameSceneClass = MockDataModelObjects.MockGameScene.self

        gvc.loadLevel(number: 7)
        
        let scene: GameScene = (gvc.view as! SKView).scene as! GameScene
        
        // Have player push crate down onto only storage space
        let swipeDownTracker: SwipeDownTracker = scene.trackers.filter( { type(of: $0) == SwipeDownTracker.self } )[0] as! SwipeDownTracker
        swipeDownTracker.swipedDown(sender: UISwipeGestureRecognizer())

        let slvc: SelectLevelViewController = createSelectLevelViewController(withConstants: SwipeTracker.constants)
    
        XCTAssert(slvc.constants.completeLevels.contains(7))
    }
    
    func testCompletedLevelsAreCheckmarkedInSelectLevelViewController() {
        SwipeTracker.constants = MockDataModelObjects.MockConstants()
        SwipeTracker.gameSceneClass = MockDataModelObjects.MockGameScene.self

        gvc.loadLevel(number: 7)
        
        let scene: GameScene = (gvc.view as! SKView).scene as! GameScene
        
        // Have player push crate down onto only storage space
        let swipeDownTracker: SwipeDownTracker = scene.trackers.filter( { type(of: $0) == SwipeDownTracker.self } )[0] as! SwipeDownTracker
        swipeDownTracker.swipedDown(sender: UISwipeGestureRecognizer())
        
        let slvc: SelectLevelViewController = createSelectLevelViewController(withConstants: SwipeTracker.constants)

        let numCheckedCells = slvc.collectionView.visibleCells.filter { (cell: UICollectionViewCell) in
            return !(cell as! LevelCell).checkmarkView.isHidden
        }.count

        XCTAssertEqual(slvc.collectionView.visibleCells.count, 12)
        XCTAssertEqual(numCheckedCells, 1)
    }

}
