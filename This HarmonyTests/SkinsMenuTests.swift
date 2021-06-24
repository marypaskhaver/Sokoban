//
//  SkinsMenuTests.swift
//  This HarmonyTests
//
//  Created by Mary Paskhaver on 6/24/21.
//

import XCTest
import SpriteKit

@testable import This_Harmony

class SkinsMenuTests: XCTestCase {
    var gc: GameViewController!
    var skinsMenu: SkinsMenu!

    override func setUpWithError() throws {
        super.setUp()
        
        CoreDataManager.gameSceneClass = MockDataModelObjects.MockGameScene.self
        gc = MockDataModelObjects().createGameViewController()
        Tile.constants = MockDataModelObjects.MockConstants()
        
        gc.presentSkinsMenu()
        skinsMenu = (gc.view as! SKView).scene as! SkinsMenu
    }
    
    func testPlayerImagesNotNilWhenLoaded() {
        XCTAssertNotNil(skinsMenu.playerImage)
        XCTAssertNotNil(skinsMenu.playerImageLeft)
        XCTAssertNotNil(skinsMenu.playerImageRight)
    }
    
}
