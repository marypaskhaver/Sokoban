//
//  PauseMenuBox.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 3/9/21.
//

import Foundation
import SpriteKit

class PauseMenuBoxMaker {
    
    func getBox(for gameScene: GameScene) -> SKShapeNode {
        let menuBox: SKShapeNode = SKShapeNode(rect: CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: 500, height: 700))
        menuBox.zPosition = 2
        menuBox.fillColor = .white
        menuBox.name = "menu-box"
        
        let levelMenuLabel: MSButtonNode = MSButtonNode(SKTexture(imageNamed: "level_menu_button"), CGSize(width: 200, height: 100), atPosition: CGPoint(x: menuBox.frame.midX, y: menuBox.frame.midY))

        levelMenuLabel.selectedHandler = {
            gameScene.gvc.presentLevelMenu()
        }
        
        menuBox.addChild(levelMenuLabel)
        
        return menuBox
    }
    
}
