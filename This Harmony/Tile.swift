//
//  Tile.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 1/1/21.
//

import SpriteKit

class Tile: SKSpriteNode {
    var row: Int = 0
    var column: Int = 0
    
    init(texture: SKTexture, name: String, row: Int, column: Int) {
        super.init(texture: texture, color: UIColor.red, size: CGSize(width: 80, height: 80))
        self.row = row
        self.column = column
        self.name = name
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
