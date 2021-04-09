//
//  PauseMenuBox.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 3/9/21.
//

import Foundation
import SpriteKit

enum MenuBox {
    case pauseLevelMenu, levelCompleteMenu
}

class MenuBoxMaker {
    
    func getBox(ofType type: MenuBox, for gameScene: GameScene) -> SKShapeNode {
        switch (type) {
            case .pauseLevelMenu:
                return getPauseLevelMenu(for: gameScene)
            case .levelCompleteMenu:
                return getLevelCompleteMenu(for: gameScene)
            }
    }
    
    private func getPauseLevelMenu(for gameScene: GameScene) -> SKShapeNode {
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
    
    private func getLevelCompleteMenu(for gameScene: GameScene) -> SKShapeNode {
        let menuBox: SKShapeNode = SKShapeNode(rect: CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: 200, height: 500))
        menuBox.zPosition = 2
        menuBox.fillColor = .red
        
        return menuBox
    }
    
}
