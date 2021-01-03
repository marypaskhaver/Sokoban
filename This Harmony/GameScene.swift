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
    var grid: Grid?
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        // Setup player
        // Make sure the child actually is of the Player class
        if let somePlayer: Player = self.childNode(withName: "player") as? Player {
            // Make the declared variable equal to somePlayer
            player = somePlayer
        }
        
        let gridCreator: GridCreator = GridCreator()
        grid = Grid(with2DArrayOfTiles: gridCreator.getGridOfScenesChildren(children), withPlayerNode: gridCreator.player!) // There will always be a player
        let childrenToAdd: [SKNode] = gridCreator.childrenToAddToView // There will always be some crates 
        
        for child in childrenToAdd {
            // Calculate position for drawing floors underneath the player and crates
            let tile: Tile = child as! Tile
            child.position = CGPoint(x: tile.column * Constants.tileSize + 64, y: 656 - (tile.row * Constants.tileSize))
            
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
        
    @objc func swipedRight(sender: UISwipeGestureRecognizer) {
        grid?.movePlayer(inDirection: .right)
    }
    
    @objc func swipedLeft(sender: UISwipeGestureRecognizer) {
        grid?.movePlayer(inDirection: .left)
    }
    
    @objc func swipedUp(sender: UISwipeGestureRecognizer) {
        grid?.movePlayer(inDirection: .up)
    }
    
    @objc func swipedDown(sender: UISwipeGestureRecognizer) {
        grid?.movePlayer(inDirection: .down)
    }
    
}
