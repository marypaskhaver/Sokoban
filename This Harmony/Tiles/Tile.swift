//
//  Tile.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 1/1/21.
//

import SpriteKit

class Tile: SKSpriteNode {
    static var constants: Constants = Constants()
    
    init(texture: SKTexture, name: String) {
        super.init(texture: texture, color: UIColor.red, size: CGSize(width: Tile.constants.tileSize, height: Tile.constants.tileSize))
        self.name = name
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
