//
//  SwipeTracker.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 4/9/21.
//

import Foundation

class SwipeTracker {
    var gameScene: GameScene!
    
    func showGameScenesLevelCompleteMenu() {
        if self.gameScene.grid.isLevelComplete() {
            Constants.completeLevels.append(GameScene.level)
            self.gameScene.showLevelCompleteMenu()
        }
    }
}

