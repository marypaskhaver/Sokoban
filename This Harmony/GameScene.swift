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
        
        var arrayOfNodes: [SKSpriteNode] = []
        
        for child in children {
            arrayOfNodes.append(child as! SKSpriteNode)
        }
        
        arrayOfNodes = arrayOfNodes.sorted(by: { $0.frame.midX < $1.frame.midX })
        arrayOfNodes = arrayOfNodes.sorted(by: { $0.frame.midY > $1.frame.midY })
        
        var arrayOfNodes2D: [[SKSpriteNode]] = [ [SKSpriteNode] ]()
        
        arrayOfNodes2D = arrayOfNodes.chunked(into: 12)
        
        for r in arrayOfNodes2D {
            var row = r
            row = row.sorted(by: { $0.frame.midX < $1.frame.midX })
        }

        // Create array from nodes in self.children and sort them by their x and y values
        // Start w/ lowest x and highest y
        // Go thru all the x's on that y level
        // Then decrease y level
        
                
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
    
    // Check if pathway is clear of walls and other crates before moving?
    // What if the player can only move forward if the block in front of them is of type "floor"? But then how would they push crates?
    
    @objc func swipedRight(sender: UISwipeGestureRecognizer) {
//        if (playerCanMoveRight()) {
            player.moveRight(byNumTiles: 1)
            // Call player.animate method to change image-- later
            // Move crate if needed
//        }
        
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
        print("contact")
    }
    
    func didEnd(_ contact: SKPhysicsContact) {

    }
    
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
