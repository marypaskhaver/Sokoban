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
    
    func updateImage() {
        if isOnStorageArea {
            self.color = UIColor.green
            self.colorBlendFactor = 0.4
        } else {
            self.colorBlendFactor = 0
            self.texture = SKTexture(imageNamed: "crate")
        }
    }
}
