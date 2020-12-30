//
//  GameScene.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 12/29/20.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player: Player = Player()
    let tileSize: CGFloat = 80.0
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        // Setup player
        // Make sure the child actually is of the Player class
        if let somePlayer: Player = self.childNode(withName: "player") as? Player {
            // Make the declared variable equal to somePlayer
            player = somePlayer
        }
        
        for node in children {
            if node.name == "crate" {
                // Adjust bounding rect so to avoid corner collisions
                node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: node.frame.width - 1, height: node.frame.height - 1))
                node.physicsBody?.mass = 0.00000001
            }
        }
                
        let swipeRight: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedRight(sender:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)

        let swipeLeft: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedLeft(sender:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)

        let swipeUp: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedUp(sender:)))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)

        let swipeDown: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedDown(sender:)))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
    }
    
    @objc func swipedRight(sender: UISwipeGestureRecognizer) {
        player.moveRight(byNumTiles: 1)
        // Call player.animate method to change image-- later
    }
    
    @objc func swipedLeft(sender: UISwipeGestureRecognizer) {
        player.moveLeft(byNumTiles: 1)
        // Call player.animate method to change image-- later
    }
    
    @objc func swipedUp(sender: UISwipeGestureRecognizer) {
        player.moveUp(byNumTiles: 1)
        // Call player.animate method to change image-- later
    }
    
    @objc func swipedDown(sender: UISwipeGestureRecognizer) {
        player.moveDown(byNumTiles: 1)
        // Call player.animate method to change image-- later
    }
    
    func didBegin(_ contact: SKPhysicsContact) {

    }
    
    func didEnd(_ contact: SKPhysicsContact) {

    }
    
}
