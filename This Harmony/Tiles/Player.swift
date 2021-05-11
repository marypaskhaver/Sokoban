//
//  Player.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 12/30/20.
//

import Foundation
import SpriteKit

class Player: MovableTile {
    
    override func moveRight(byNumTiles numTiles: Int) {
        super.moveRight(byNumTiles: numTiles)
        
        let currentTextureName: String = Constants().levelThemes[GameScene.level]!.playerImage
        
        let anim = SKAction.animate(with: [
                    SKTexture(imageNamed: currentTextureName + "_walkr_1"),
                    SKTexture(imageNamed: currentTextureName + "_walkr_2"),
                    SKTexture(imageNamed: currentTextureName + "_walkr_stand")
                    ], timePerFrame: 0.15)
        
        self.run(SKAction.repeat(anim, count: 1))
    }
    
    override func moveLeft(byNumTiles numTiles: Int) {
        super.moveLeft(byNumTiles: numTiles)
        
        let currentTextureName: String = Constants().levelThemes[GameScene.level]!.playerImage
        
        let anim = SKAction.animate(with: [
                    SKTexture(imageNamed: currentTextureName + "_walkl_1"),
                    SKTexture(imageNamed: currentTextureName + "_walkl_2"),
                    SKTexture(imageNamed: currentTextureName + "_walkl_stand")
                    ], timePerFrame: 0.15)
        
        self.run(SKAction.repeat(anim, count: 1))
    }
    
    override func moveUp(byNumTiles numTiles: Int) {
        super.moveUp(byNumTiles: numTiles)
        
        let currentTextureName: String = Constants().levelThemes[GameScene.level]!.playerImage
        
        let anim = SKAction.animate(with: [
                    SKTexture(imageNamed: currentTextureName + "_walku_1"),
                    SKTexture(imageNamed: currentTextureName + "_walku_2"),
                    SKTexture(imageNamed: currentTextureName + "_walku_stand")
                    ], timePerFrame: 0.15)
        
        self.run(SKAction.repeat(anim, count: 1))
    }
    
    override func moveDown(byNumTiles numTiles: Int) {
        super.moveDown(byNumTiles: numTiles)
        
        let currentTextureName: String = Constants().levelThemes[GameScene.level]!.playerImage
        
        let anim = SKAction.animate(with: [
                    SKTexture(imageNamed: currentTextureName + "_walkd_1"), // Assumes all images are named in similar format
                    SKTexture(imageNamed: currentTextureName + "_walkd_2"),
                    SKTexture(imageNamed: currentTextureName) // Current texture when standing still-- right now, all player images load looking down
                    ], timePerFrame: 0.15)
        
        self.run(SKAction.repeat(anim, count: 1))
    }
}
