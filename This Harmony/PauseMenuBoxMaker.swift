//
//  PauseMenuBox.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 3/9/21.
//

import Foundation
import SpriteKit

class PauseMenuBoxMaker {
    
    func getBox() -> SKShapeNode {
        let menuBox: SKShapeNode = SKShapeNode(rect: CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: 500, height: 700))
        menuBox.zPosition = 2
        menuBox.fillColor = .white
        menuBox.name = "menu-box"
        
        return menuBox
    }
    
}
