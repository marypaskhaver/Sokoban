//
//  LaserPointer.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 1/20/21.
//

import SpriteKit

class LaserPointer: Tile {
    var direction: Direction!
    var degreeAndDirectionDict: [Int : Direction] = [Int : Direction]()
    
    func setDirection() {
        degreeAndDirectionDict[0] = .up
        degreeAndDirectionDict[-180] = .down
        degreeAndDirectionDict[90] = .left
        degreeAndDirectionDict[-90] = .right
        
        self.direction = degreeAndDirectionDict[Int(self.zRotation)]
    }
   
}
