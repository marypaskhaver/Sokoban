//
//  SwipeUpTracker.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 3/19/21.
//

import UIKit

class SwipeUpTracker: SwipeTracker {
    
    init(for gameScene: GameScene) {
        super.init()

        self.gameScene = gameScene
        
        let swipeUp: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedUp(sender:)))
        swipeUp.direction = .up
        
        self.gameScene.view!.addGestureRecognizer(swipeUp)
    }
    
    @objc func swipedUp(sender: UISwipeGestureRecognizer) {
        self.gameScene.grid.movePlayer(inDirection: .up)
        self.gameScene.stepsLabel.text = "Steps: \(self.gameScene.grid.currentSteps)"
        
        super.showGameScenesLevelCompleteMenu()
    }
}
