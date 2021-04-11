//
//  This_HarmonyTests.swift
//  This HarmonyTests
//
//  Created by Mary Paskhaver on 12/29/20.
//

import XCTest
import SpriteKit

@testable import This_Harmony

class This_HarmonyTests: XCTestCase {
    var gc: GameViewController!
    
    override func setUpWithError() throws {
        super.setUp()
        
        gc = MockDataModelObjects().createGameViewController()
    }
    
    func testLevel1GridExist() {
        let scene: GameScene = (gc.view as! SKView).scene as! GameScene
        XCTAssertNotNil(scene.grid)
    }
    
    func testCantGoToPrevLevelFromLevel1() {
        var scene: GameScene = (gc.view as! SKView).scene as! GameScene
        XCTAssert(scene.buttonPrevious.state == .disabled)
        
        scene.goToNextLevel()
        
        // When the next level is loaded, a new GameScene is presented in GameScene's view
        scene = (gc.view as! SKView).scene as! GameScene
        XCTAssert(scene.buttonPrevious.state == .active)
    }
    
    func testCantGoToNextLevelFromLastLevel() {
        gc.loadLevel(number: Constants.numLevels) // Currently the last level
        var scene: GameScene = (gc.view as! SKView).scene as! GameScene
        XCTAssert(scene.buttonNext.state == .disabled)

        scene.goToPreviousLevel()

        // When the previous level is loaded, a new GameScene is presented in GameScene's view
        scene = (gc.view as! SKView).scene as! GameScene
        XCTAssert(scene.buttonNext.state == .active)
    }
    
    func testStepDataGetsUpdatedWhenLevelIsCompletedInFewerSteps() {
        // Default # of lowestSteps stored in CoreData is 0
        let scene: GameScene = (gc.view as! SKView).scene as! GameScene
        
        XCTAssert(gc.cdm.fetchCompletedLevelWithLowestSteps().lowestSteps == 0)

        scene.grid.currentSteps = 10 // Current steps are lower than previously saved lowestSteps-- user beat the level in less moves
        scene.grid.lowestSteps = 20 // So 10 should be saved as new lowestSteps
        
        scene.showLevelCompleteMenu()
        
        print(gc.cdm.fetchCompletedLevelWithLowestSteps().lowestSteps)
        
        XCTAssert(gc.cdm.fetchCompletedLevelWithLowestSteps().lowestSteps == 10)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

}
