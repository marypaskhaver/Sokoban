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
    
    init() {
        super.init(texture: SKTexture(imageNamed: "floor"), name: Constants.TileNames.floor.rawValue)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
  
}
