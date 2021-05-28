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
    var laserBeams: [LaserBeam] = [LaserBeam]()
    
    func setDirection() {
        degreeAndDirectionDict[0] = .up
        degreeAndDirectionDict[180] = .down
        degreeAndDirectionDict[-180] = .down
        degreeAndDirectionDict[90] = .left
        degreeAndDirectionDict[-90] = .right
                
        // Convert zRotation to degrees
        self.direction = degreeAndDirectionDict[Int(self.zRotation * (180 / .pi ))]
        
        animate()
    }
    
    private func animate() {
        let images: [String] = Tile.constants.getLevelTheme().laserPointerImages
        
        if images.count == 1 {
            return
        }
        
        var skTexturesOfLaserPointerImages: [SKTexture] = []

        for image in images.filter( { $0.contains("_" + getDirectionLetter(forDirection: self.direction) + "_") }) {
            skTexturesOfLaserPointerImages.append(SKTexture(imageNamed: image))
        }
            
        let anim = SKAction.animate(with: skTexturesOfLaserPointerImages, timePerFrame: 1)
        self.run(SKAction.repeatForever(anim))
    }
    
    private func getDirectionLetter(forDirection dir: Direction) -> String {
        switch dir {
        case .right:
            return "r"
        case .left:
            return "l"
        case .up:
            return "u"
        case .down:
            return "d"
        }
    }
   
}
