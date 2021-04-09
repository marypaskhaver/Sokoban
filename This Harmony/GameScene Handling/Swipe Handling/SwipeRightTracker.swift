//
//  SwipeRightTracker.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 3/19/21.
//

import UIKit

class SwipeRightTracker {
    var gameScene: GameScene!
    
    init(for gameScene: GameScene) {
        self.gameScene = gameScene
        
        let swipeRight: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedRight(sender:)))
        swipeRight.direction = .right
        
        self.gameScene.view!.addGestureRecognizer(swipeRight)
    }
    
    @objc func swipedRight(sender: UISwipeGestureRecognizer) {
        self.gameScene.grid.movePlayer(inDirection: .right)
        self.gameScene.stepsLabel.text = "Steps: \(self.gameScene.grid.steps)"
        
        if self.gameScene.grid.isLevelComplete() {
            Constants.completeLevels.append(GameScene.level)
            self.gameScene.showLevelCompleteMenu()
        }
    }
}
