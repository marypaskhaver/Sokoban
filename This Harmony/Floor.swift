//
//  Floor.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 12/31/20.
//

import Foundation
import SpriteKit

class Floor: Tile {
    var player: SKSpriteNode?
    var crate: SKSpriteNode?
    
    init(row: Int, column: Int) {
        super.init(texture: SKTexture(imageNamed: "floor"), name: "floor", row: row, column: column)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
  
}
