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
        self.run(SKAction.moveBy(x: CGFloat(numTiles * MovableTile.constants.tileSize), y: 0, duration: MovableTile.constants.movementAnimationDuration))
    }
    
    func moveLeft(byNumTiles numTiles: Int) {
        self.run(SKAction.moveBy(x: CGFloat(-numTiles * MovableTile.constants.tileSize), y: 0, duration: MovableTile.constants.movementAnimationDuration))
    }
    
    func moveUp(byNumTiles numTiles: Int) {
        self.run(SKAction.moveBy(x: 0, y: CGFloat(numTiles * MovableTile.constants.tileSize), duration: MovableTile.constants.movementAnimationDuration))
    }
    
    func moveDown(byNumTiles numTiles: Int) {
        self.run(SKAction.moveBy(x: 0, y: CGFloat(-numTiles * MovableTile.constants.tileSize), duration: MovableTile.constants.movementAnimationDuration))
    }
    
}
