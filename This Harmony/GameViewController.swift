//
//  GameViewController.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 12/29/20.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            if let scene = MainMenu(fileNamed: "MainMenu") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                scene.gvc = self
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
 
    func presentLevelMenu() {
        self.performSegue(withIdentifier: "showLevelMenu", sender: self)
    }
    
    func loadLevel(number: Int) {
        // Grab reference to our SpriteKit view
        guard let skView = self.view as! SKView? else {
            print("Could not get SKView")
            return
        }

        guard let gameScene = GameScene.getLevel(number) else {
            print("Could not load GameScene with level \(number)")
            return
        }

        GameScene.level = number
        gameScene.gvc = self
        
        // Ensure correct aspect mode
        gameScene.scaleMode = .aspectFill

        // Show debug
        skView.showsPhysics = true
        skView.showsDrawCount = true
        skView.showsFPS = true

        // Start game scene
        skView.presentScene(gameScene)
    }
    
}
