//
//  Floor.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 12/31/20.
//

import Foundation
import SpriteKit

class Floor: Tile {
    var player: Player?
    var crate: Crate?
    var laserBeams: [LaserBeam] = [LaserBeam]()
    
    let textureImage: SKTexture

    init(withTexture texture: SKTexture = SKTexture(imageNamed: "floor")) {
        textureImage = texture
        super.init(texture: textureImage, name: Constants.TileNames.floor.rawValue)
    }
    
    required init?(coder aDecoder: NSCoder) {
        textureImage = SKTexture(imageNamed: "floor")
        super.init(coder: aDecoder)
    }
    
    func setCrate(to crate: Crate) {
        if crate.isOnStorageArea {
            crate.isOnStorageArea = false
            crate.updateImage()
        }
    
        self.crate = crate
    }
    
    func setCrateToNil() {
        self.crate = nil
    }
  
}
