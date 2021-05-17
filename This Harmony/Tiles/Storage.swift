//
//  Storage.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 1/4/21.
//

import Foundation
import SpriteKit

class Storage: Floor {
    
    override func setCrate(to crate: Crate) {
        crate.isOnStorageArea = true
        crate.updateImage()
        self.crate = crate
    }
    
}
