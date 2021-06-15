//
//  Crate.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 12/30/20.
//

import Foundation
import SpriteKit

class Crate: MovableTile {
    var isOnStorageArea: Bool = false
    var isOnActiveLaserBeam: Bool = false
    
    override init(texture: SKTexture, name: String) {
        super.init(texture: texture, name: name)
        self.zPosition = 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func updateImage() {
        if isOnStorageArea {
            self.color = UIColor.green
            self.colorBlendFactor = 0.4
        } else {
            self.colorBlendFactor = 0
            self.texture = SKTexture(imageNamed: Tile.constants.getLevelTheme().crateImage)
        }
    }
}
