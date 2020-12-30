//
//  MovableTile.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 12/30/20.
//

import Foundation
import SpriteKit

class MovableTile: SKSpriteNode {
    
    func moveRight(byNumTiles numTiles: Int) {
        self.run(SKAction.moveBy(x: CGFloat(numTiles * 80), y: 0, duration: 0.2))
    }
    
    func moveLeft(byNumTiles numTiles: Int) {
        self.run(SKAction.moveBy(x: CGFloat(-numTiles * 80), y: 0, duration: 0.2))
    }
    
    func moveUp(byNumTiles numTiles: Int) {
        self.run(SKAction.moveBy(x: 0, y: CGFloat(numTiles * 80), duration: 0.2))
    }
    
    func moveDown(byNumTiles numTiles: Int) {
        self.run(SKAction.moveBy(x: 0, y: CGFloat(-numTiles * 80), duration: 0.2))
    }
}
