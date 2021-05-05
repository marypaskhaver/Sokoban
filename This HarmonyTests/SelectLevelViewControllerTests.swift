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
    var slvc: SelectLevelViewController!

    override func setUpWithError() throws {
        super.setUp()
        
        gvc = MockDataModelObjects().createGameViewController()
    }
    
    func testSelectLevelViewControllerNumberOfCellsEqualsNumberOfLevels() {
        let slvc: SelectLevelViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SelectLevelViewController")
        slvc.constants = MockDataModelObjects.MockConstants()
        slvc.collectionView.layoutIfNeeded()
      
        XCTAssertEqual(slvc.collectionView.visibleCells.count, MockDataModelObjects.MockConstants().numLevels)

    }

}
