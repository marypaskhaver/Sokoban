//
//  PlayerMoverTests.swift
//  This HarmonyTests
//
//  Created by Mary Paskhaver on 4/16/21.
//

import XCTest
import SpriteKit

@testable import This_Harmony

class PlayerMoverTests: XCTestCase {
    var gc: GameViewController!

    override func setUpWithError() throws {
        super.setUp()
        
        gc = MockDataModelObjects().createGameViewController()
        Floor.defaultTexture = SKTexture(imageNamed: Constants.TileNames.floor.rawValue)
    }
    
    func testPlayerCantMoveOutsideGridWallBounds() {
        gc.loadLevel(number: 1)
        let scene: GameScene = (gc.view as! SKView).scene as! GameScene
        let mover: PlayerMover = PlayerMover(with2DArrayOfTiles: scene.grid.grid)
        
        let playerPosition: GridPoint = GridInformation(withGrid: mover.grid).getPlayerRowAndCol()
        XCTAssertEqual(playerPosition.row, 1)
        XCTAssertFalse(mover.canPlayerMove(inDirection: .up))
        
        XCTAssertEqual(playerPosition.col, 1)
        XCTAssertFalse(mover.canPlayerMove(inDirection: .left))
        
        // Assumes levels are squares / rectangles, outer edges = Wall border
        let maxRow: Int = scene.grid.grid.count - 2 // - 1 would have gotten us the wall; we're going to right next to the wall
        let maxCol: Int = scene.grid.grid[maxRow].count - 2
        
        // Set player position to max value
        let player: Player = ((scene.grid.grid[GridInformation(withGrid: mover.grid).getPlayerRowAndCol().row][GridInformation(withGrid: mover.grid).getPlayerRowAndCol().col]) as! Floor).player!
        let topLeftNode: Tile = scene.grid.grid[0][0]
        player.position = CGPoint(x: CGFloat(maxCol * Constants().tileSize) + topLeftNode.position.x, y: -(CGFloat(maxRow * Constants().tileSize) - topLeftNode.position.y))
        
        ((scene.grid.grid[GridInformation(withGrid: mover.grid).getPlayerRowAndCol().row][GridInformation(withGrid: mover.grid).getPlayerRowAndCol().col]) as! Floor).player = nil
        ((scene.grid.grid[maxRow][maxCol]) as! Floor).player = player
        
        XCTAssertFalse(mover.canPlayerMove(inDirection: .down))
        XCTAssertFalse(mover.canPlayerMove(inDirection: .right))
    }
    
    func playerCantMoveInAllDirections(withMover mover: PlayerMover) {
        XCTAssertFalse(mover.canPlayerMove(inDirection: .up))
        XCTAssertFalse(mover.canPlayerMove(inDirection: .down))
        XCTAssertFalse(mover.canPlayerMove(inDirection: .left))
        XCTAssertFalse(mover.canPlayerMove(inDirection: .right))
    }
    
    func testPlayerCantMoveThroughWall() {
        gc.loadLevel(number: 3)
        let scene: GameScene = (gc.view as! SKView).scene as! GameScene
        let mover: PlayerMover = PlayerMover(with2DArrayOfTiles: scene.grid.grid)
        
        playerCantMoveInAllDirections(withMover: mover)
    }
    
    func testPlayerCantPushTwoCratesAtOnce() {
        gc.loadLevel(number: 4)
        let scene: GameScene = (gc.view as! SKView).scene as! GameScene
        let mover: PlayerMover = PlayerMover(with2DArrayOfTiles: scene.grid.grid)
        
        playerCantMoveInAllDirections(withMover: mover)
    }
    
    func testPlayerCantPushCrateThroughWall() {
        gc.loadLevel(number: 5)
        let scene: GameScene = (gc.view as! SKView).scene as! GameScene
        let mover: PlayerMover = PlayerMover(with2DArrayOfTiles: scene.grid.grid)
        
        playerCantMoveInAllDirections(withMover: mover)
    }
    
    func testPlayerCantMoveThroughLaserBeams() {
        gc.loadLevel(number: 6)
        let scene: GameScene = (gc.view as! SKView).scene as! GameScene
        let mover: PlayerMover = PlayerMover(with2DArrayOfTiles: scene.grid.grid)
        
        playerCantMoveInAllDirections(withMover: mover)
    }
    
    // Check in all directions
    func testPlayerCantPushCratesOnBeamsEvenIfGoingTowardLaserPointerUp() {
        gc.loadLevel(number: 7)
        let scene: GameScene = (gc.view as! SKView).scene as! GameScene
        let mover: PlayerMover = PlayerMover(with2DArrayOfTiles: scene.grid.grid)

        XCTAssertFalse(mover.canPlayerMove(inDirection: .up))
    }
    
    func testPlayerCantPushCratesOnBeamsEvenIfGoingTowardLaserPointerRight() {
        gc.loadLevel(number: 10)
        let scene: GameScene = (gc.view as! SKView).scene as! GameScene
        let mover: PlayerMover = PlayerMover(with2DArrayOfTiles: scene.grid.grid)

        XCTAssertFalse(mover.canPlayerMove(inDirection: .right))
    }
    
    func testPlayerCantPushCratesOnBeamsEvenIfGoingTowardLaserPointerDown() {
        gc.loadLevel(number: 11)
        let scene: GameScene = (gc.view as! SKView).scene as! GameScene
        let mover: PlayerMover = PlayerMover(with2DArrayOfTiles: scene.grid.grid)

        XCTAssertFalse(mover.canPlayerMove(inDirection: .down))
    }
    
    func testPlayerCantPushCratesOnBeamsEvenIfGoingTowardLaserPointerLeft() {
        gc.loadLevel(number: 12)
        let scene: GameScene = (gc.view as! SKView).scene as! GameScene
        let mover: PlayerMover = PlayerMover(with2DArrayOfTiles: scene.grid.grid)

        XCTAssertFalse(mover.canPlayerMove(inDirection: .left))
    }
    
    func testPlayerCanPushCrateOnBeamIfGoingTowardLaserPointer() {
        gc.loadLevel(number: 8)
        let scene: GameScene = (gc.view as! SKView).scene as! GameScene
        let mover: PlayerMover = PlayerMover(with2DArrayOfTiles: scene.grid.grid)
        
        XCTAssertTrue(mover.canPlayerMove(inDirection: .up))
        XCTAssertTrue(mover.canPlayerMove(inDirection: .down))
        XCTAssertTrue(mover.canPlayerMove(inDirection: .left))
        XCTAssertTrue(mover.canPlayerMove(inDirection: .right))
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        gc = nil
    }
}
