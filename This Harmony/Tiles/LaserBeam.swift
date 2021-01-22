//
//  LaserBeam.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 1/20/21.
//

import SpriteKit

class LaserBeam: Tile {
    var directionAndDegreeDict: [Direction : Int] = [Direction : Int]()
    
    func rotate(toBePointing dir: Direction) {
        directionAndDegreeDict[.up] = 0
        directionAndDegreeDict[.down] = 180
        directionAndDegreeDict[.left] = 90
        directionAndDegreeDict[.right] = -90
                
        // Convert degrees to zRotation radians
        self.zRotation = CGFloat(directionAndDegreeDict[dir]!) * (.pi / 180)
    }
    
    init(inDirection dir: Direction, atPoint pt: CGPoint) {
        super.init(texture: SKTexture(imageNamed: "laser_beam_pointing_up"), name: Constants.TileNames.laserBeam.rawValue)
        self.position = pt
        rotate(toBePointing: dir)
        self.zPosition = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}