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
        
        let currentTextureName: String = Player.constants.getLevelTheme().playerImage

        let anim = SKAction.animate(with: [
                    SKTexture(imageNamed: currentTextureName + "_" + dirLetter + "_1"),
                    SKTexture(imageNamed: currentTextureName + "_" + dirLetter + "_2"),
                    SKTexture(imageNamed: currentTextureName + "_" + dirLetter + "_stand")
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
    
    // The SKScenes / levels are created with a default player image, but this doesn't always correspond with the actual Theme's image. Ex: I used a beach_player to make Jungle levels but a Jungle level's actual player would be the blond_girl sprite. This func replaces the beach_player with the theme's actual playerImage: the right sprite.
    func setTextureToLevelThemePlayerImage() {
        self.texture = SKTexture(imageNamed: Tile.constants.getLevelTheme().playerImage + "_d_stand")
    }
}
