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
    
    func getPlayerPosition(inScene scene: GameScene) -> CGPoint {
        for row in 0..<scene.grid.grid.count {
            for col in 0..<scene.grid.grid[row].count {
                if scene.grid.grid[row][col] as? Floor != nil {
                    let node: Floor = scene.grid.grid[row][col] as! Floor

                    if node.player != nil {
                        return node.position
                    }
                }
            }
        }
        
        return CGPoint(x: -1, y: -1)
    }
    
    // MARK: - Test Swiping Down
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
    
    func testSwipingDownMovesPlayerPositionOnScreen() {
        gc.loadLevel(number: 9)
        
        let scene: GameScene = (gc.view as! SKView).scene as! GameScene
        
        let originalplayerPosition: CGPoint = getPlayerPosition(inScene: scene)
        
        let swipeDownTracker: SwipeDownTracker = scene.trackers.filter( { type(of: $0) == SwipeDownTracker.self } )[0] as! SwipeDownTracker
        swipeDownTracker.swipedDown(sender: UISwipeGestureRecognizer())
        
        let newPlayerPosition: CGPoint = getPlayerPosition(inScene: scene)

        XCTAssertEqual(originalplayerPosition.x, newPlayerPosition.x)
        XCTAssertEqual(originalplayerPosition.y - CGFloat(Constants.tileSize), newPlayerPosition.y)
    }
    
    // MARK: Test Swiping Up
    func testSwipingUpMovesPlayerUpInGrid() {
        gc.loadLevel(number: 9)
        
        let scene: GameScene = (gc.view as! SKView).scene as! GameScene
        let mover: PlayerMover = PlayerMover(with2DArrayOfTiles: scene.grid.grid)
        
        let originalplayerPosition: GridPoint = GridInformation(withGrid: mover.grid).getPlayerRowAndCol()
        
        let swipeUpTracker: SwipeUpTracker = scene.trackers.filter( { type(of: $0) == SwipeUpTracker.self } )[0] as! SwipeUpTracker
        swipeUpTracker.swipedUp(sender: UISwipeGestureRecognizer())
        
        let newPlayerPosition: GridPoint = GridInformation(withGrid: mover.grid).getPlayerRowAndCol()

        XCTAssertEqual(originalplayerPosition.row - 1, newPlayerPosition.row)
        XCTAssertEqual(originalplayerPosition.col, newPlayerPosition.col)
    }
    
    func testSwipingUpMovesPlayerPositionOnScreen() {
        gc.loadLevel(number: 9)
        
        let scene: GameScene = (gc.view as! SKView).scene as! GameScene
        
        let originalplayerPosition: CGPoint = getPlayerPosition(inScene: scene)
        
        let swipeUpTracker: SwipeUpTracker = scene.trackers.filter( { type(of: $0) == SwipeUpTracker.self } )[0] as! SwipeUpTracker
        swipeUpTracker.swipedUp(sender: UISwipeGestureRecognizer())

        let newPlayerPosition: CGPoint = getPlayerPosition(inScene: scene)

        XCTAssertEqual(originalplayerPosition.x, newPlayerPosition.x)
        XCTAssertEqual(originalplayerPosition.y + CGFloat(Constants.tileSize), newPlayerPosition.y)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        gc = nil
    }
}
