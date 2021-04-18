//
//  SwipeTrackerTests.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 4/18/21.
//

import XCTest
import SpriteKit

@testable import This_Harmony

class SwipeTrackerTests: XCTestCase {
    var gc: GameViewController!

    override func setUpWithError() throws {
        super.setUp()
        
        gc = MockDataModelObjects().createGameViewController()
    }
    
    func testSwipingDownMovesPlayerDownInGrid() {
        gc.loadLevel(number: 9)
        
        let scene: GameScene = (gc.view as! SKView).scene as! GameScene
        let mover: PlayerMover = PlayerMover(with2DArrayOfTiles: scene.grid.grid)
        
        let originalplayerPosition: GridPoint = GridInformation(withGrid: mover.grid).getPlayerRowAndCol()
        
        let swipeDownTracker: SwipeDownTracker = scene.trackers.filter( { type(of: $0) == SwipeDownTracker.self } )[0] as! SwipeDownTracker
        swipeDownTracker.swipedDown(sender: UISwipeGestureRecognizer())
        
        let newPlayerPosition: GridPoint = GridInformation(withGrid: mover.grid).getPlayerRowAndCol()

        XCTAssertEqual(originalplayerPosition.row + 1, newPlayerPosition.row)
        XCTAssertEqual(originalplayerPosition.col, newPlayerPosition.col)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        gc = nil
    }
}
