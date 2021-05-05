//
//  MovableTile.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 12/30/20.
//

import Foundation
import SpriteKit

class MovableTile: Tile {
    
    func moveRight(byNumTiles numTiles: Int) {
        self.run(SKAction.moveBy(x: CGFloat(numTiles * Constants().tileSize), y: 0, duration: Constants().movementAnimationDuration))
    }
    
    func moveLeft(byNumTiles numTiles: Int) {
        self.run(SKAction.moveBy(x: CGFloat(-numTiles * Constants().tileSize), y: 0, duration: Constants().movementAnimationDuration))
    }
    
    func moveUp(byNumTiles numTiles: Int) {
        self.run(SKAction.moveBy(x: 0, y: CGFloat(numTiles * Constants().tileSize), duration: Constants().movementAnimationDuration))
    }
    
    func moveDown(byNumTiles numTiles: Int) {
        self.run(SKAction.moveBy(x: 0, y: CGFloat(-numTiles * Constants().tileSize), duration: Constants().movementAnimationDuration))
    }
    
}
