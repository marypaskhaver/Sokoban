//
//  Player.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 12/30/20.
//

import Foundation
import SpriteKit

class Player: MovableTile {
    
    func getDirectionLetter(forDirection dir: Direction) -> String {
        switch dir {
        case .right:
            return "r"
        case .left:
            return "l"
        case .up:
            return "u"
        case .down:
            return "d"
        }
    }
    
    func createAnimationAction(inDirection dir: Direction) -> SKAction {
        let dirLetter: String = getDirectionLetter(forDirection: dir)
        
        let currentTextureName: String = Constants().levelThemes[GameScene.level]!.playerImage
        let standImageName = currentTextureName + (dirLetter == "d" ? "" : "_\(dirLetter)_stand")
        
        let anim = SKAction.animate(with: [
                    SKTexture(imageNamed: currentTextureName + "_" + dirLetter + "_1"),
                    SKTexture(imageNamed: currentTextureName + "_" + dirLetter + "_2"),
                    SKTexture(imageNamed: standImageName)
                    ], timePerFrame: 0.15)
        
        return anim
    }
    
    override func moveRight(byNumTiles numTiles: Int) {
        super.moveRight(byNumTiles: numTiles)
        self.run(SKAction.repeat(createAnimationAction(inDirection: .right), count: 1))
    }
    
    override func moveLeft(byNumTiles numTiles: Int) {
        super.moveLeft(byNumTiles: numTiles)
        self.run(SKAction.repeat(createAnimationAction(inDirection: .left), count: 1))
    }
    
    override func moveUp(byNumTiles numTiles: Int) {
        super.moveUp(byNumTiles: numTiles)
        self.run(SKAction.repeat(createAnimationAction(inDirection: .up), count: 1))
    }
    
    override func moveDown(byNumTiles numTiles: Int) {
        super.moveDown(byNumTiles: numTiles)
        self.run(SKAction.repeat(createAnimationAction(inDirection: .down), count: 1))
    }
}
