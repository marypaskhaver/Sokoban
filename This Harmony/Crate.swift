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
    
    func updateImage() {
        if isOnStorageArea {
//            self.texture = SKTexture(imageNamed: "crateOnStorage")
            print("changing image to crateOnStorage")
        } else {
            self.texture = SKTexture(imageNamed: "crate")
            print("changing image to default crate")
        }
    }
}
