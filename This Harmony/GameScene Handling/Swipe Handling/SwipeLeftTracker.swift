//
//  SwipeLeftTracker.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 3/19/21.
//

import UIKit

class SwipeLeftTracker: SwipeTracker {
    
    init(for gameScene: GameScene) {
        super.init()
        
        self.gameScene = gameScene
        
        let swipeLeft: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedLeft(sender:)))
        swipeLeft.direction = .left
        
        self.gameScene.view!.addGestureRecognizer(swipeLeft)
    }
    
    @objc func swipedLeft(sender: UISwipeGestureRecognizer) {
        self.gameScene.grid.movePlayer(inDirection: .left)
        self.gameScene.stepsLabel.text = "Steps: \(self.gameScene.grid.steps)"
        
        super.showGameScenesLevelCompleteMenu()
    }
}
