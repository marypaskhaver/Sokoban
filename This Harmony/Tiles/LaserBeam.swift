//
//  LaserBeam.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 1/20/21.
//

import SpriteKit

class LaserBeam: Tile {
    var directionAndDegreeDict: [Direction : Int] = [Direction : Int]()
    var direction: Direction!
    
    func rotate(toBePointing dir: Direction) {
        directionAndDegreeDict[.up] = 0
        directionAndDegreeDict[.down] = 180
        directionAndDegreeDict[.left] = 90
        directionAndDegreeDict[.right] = -90
                
        // Convert degrees to zRotation radians
        self.zRotation = CGFloat(directionAndDegreeDict[dir]!) * (.pi / 180)
    }
    
    init(inDirection dir: Direction, atPoint pt: CGPoint) {
        super.init(texture: SKTexture(imageNamed: Tile.constants.getLevelTheme().laserBeamImages[0]), name: Constants.TileNames.laserBeam.rawValue)
        
        self.position = pt
        self.zPosition = 1
        self.isHidden = true // Hide initially
        
        self.direction = dir
        rotate(toBePointing: dir)
        
        animate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func animate() {
        let laserBeamImages: [String] = Tile.constants.getLevelTheme().laserBeamImages
        
        if laserBeamImages.count == 1 {
            return
        }
        
        var skTexturesOfLaserBeamImages: [SKTexture] = []
        
        for image in laserBeamImages.shuffled() {
            skTexturesOfLaserBeamImages.append(SKTexture(imageNamed: image))
        }
    
        let anim = SKAction.animate(with: skTexturesOfLaserBeamImages, timePerFrame: 0.15)
        self.run(SKAction.repeatForever(anim))
    }
    
}
