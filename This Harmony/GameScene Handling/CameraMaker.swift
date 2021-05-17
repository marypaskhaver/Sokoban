//
//  CameraMaker.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 5/17/21.
//

import Foundation
import SpriteKit

class CameraMaker {
    var scene: GameScene
    
    init(forGameScene scene: GameScene) {
        self.scene = scene
    }
    
    func addCamera() {
        // Add camera and make its position the center of the node grid
        let cam = SKCameraNode()
        let grid: Grid = scene.grid
        
        // Grid will always be a rectangle, so get x by averaging midX's of first and last node in row 0 and first and last node in column 0
        let gridMidX: CGFloat = (grid.grid[0][0].frame.midX + grid.grid[0][grid.grid[0].count - 1].frame.midX) / 2
        let gridMidY: CGFloat = (grid.grid[0][0].frame.minY + grid.grid[grid.grid.count - 1][0].frame.minY) / 2

        cam.position = CGPoint(x: gridMidX, y: gridMidY)
        
        scene.camera = cam
        scene.addChild(cam)
    }
}
