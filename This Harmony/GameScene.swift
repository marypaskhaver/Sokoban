//
//  GameScene.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 12/29/20.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player: Player?
    let tileSize: CGFloat = 80.0
    var grid: Grid?
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        // Setup player
        // Make sure the child actually is of the Player class
        if let somePlayer: Player = self.childNode(withName: "player") as? Player {
            // Make the declared variable equal to somePlayer
            player = somePlayer
        }
        
        grid = Grid(withChildren: self.children)
        let childrenToAdd: [SKNode] = grid!.childrenToAddToView // There will always be a player and some crates
        
        for child in childrenToAdd {
            // Calculate position for drawing floors underneath the player and crates
            let tile: Tile = child as! Tile
            child.position = CGPoint(x: tile.column * 80 + 64, y: 656 - (tile.row * 80))
            
            scene?.addChild(child)
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
    
    // Check if pathway is clear of walls and other crates before moving?
    // What if the player can only move forward if the block in front of them is of type "floor"? But then how would they push crates?
    
    @objc func swipedRight(sender: UISwipeGestureRecognizer) {
        grid?.canPlayerMove(inDirection: .right)

        // Call player.animate method to change image-- later
    }
    
    @objc func swipedLeft(sender: UISwipeGestureRecognizer) {
        grid?.canPlayerMove(inDirection: .left)
        // Call player.animate method to change image-- later
    }
    
    @objc func swipedUp(sender: UISwipeGestureRecognizer) {
        grid?.movePlayer(inDirection: .up)

        // They don't have to slide. They have to go their row on the grid + 64 + 80x or whatever and column at grid + 32 + 80y or whatever!!!
        // Call player.animate method to change image-- later
    }
    
    @objc func swipedDown(sender: UISwipeGestureRecognizer) {
//        print("Can player move? \(grid?.canPlayerMove(inDirection: .down))")
        grid?.movePlayer(inDirection: .down)
        // Call player.animate method to change image-- later
    }
    
    // Create method to add child to GameScene from Grid
    
    func didBegin(_ contact: SKPhysicsContact) {

    }
    
    func didEnd(_ contact: SKPhysicsContact) {

    }
    
}
