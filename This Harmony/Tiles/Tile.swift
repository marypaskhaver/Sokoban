//
//  Tile.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 1/1/21.
//

import SpriteKit

class Tile: SKSpriteNode {
    init(texture: SKTexture, name: String) {
        super.init(texture: texture, color: UIColor.red, size: CGSize(width: Constants().tileSize, height: Constants().tileSize))
        self.name = name
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
