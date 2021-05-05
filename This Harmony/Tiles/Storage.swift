//
//  Storage.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 1/4/21.
//

import Foundation
import SpriteKit

class Storage: Floor {    
    init() {
        super.init(withTexture: SKTexture(imageNamed: Constants().levelThemes[GameScene.level]!.storageImage[0]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setCrate(to crate: Crate) {
        crate.isOnStorageArea = true
        crate.updateImage()
        self.crate = crate
    }
    
}
