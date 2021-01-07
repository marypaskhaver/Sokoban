//
//  MainMenu.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 1/6/21.
//

import Foundation
import SpriteKit

class MainMenu: SKScene {

    var buttonPlay: MSButtonNode!

    override func didMove(to view: SKView) {
        // Set UI connections
        buttonPlay = self.childNode(withName: "buttonPlay") as! MSButtonNode
        
        buttonPlay.selectedHandler = {
            self.loadGame()
        }
    }
    
    func loadGame() {
        /* 1) Grab reference to our SpriteKit view */
        guard let skView = self.view as SKView? else {
            print("Could not get SKView")
            return
        }
        
        guard let scene = GameScene.level(1) else {
            print("Could not load GameScene with level 1")
            return
        }

        /* 3) Ensure correct aspect mode */
        scene.scaleMode = .aspectFill

        /* Show debug */
        skView.showsPhysics = true
        skView.showsDrawCount = true
        skView.showsFPS = true

        /* 4) Start game scene */
        skView.presentScene(scene)
    }
}
