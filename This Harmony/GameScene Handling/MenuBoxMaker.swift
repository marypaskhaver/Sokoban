//
//  PauseMenuBox.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 3/9/21.
//

import Foundation
import SpriteKit

enum MenuBox: String {
    case pauseLevelMenu = "pause-level-menu"
    case levelCompleteMenu = "level-complete-menu"
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
        let menuBox: SKShapeNode = SKShapeNode(rect: CGRect(x: UIScreen.main.bounds.midX - CGFloat(Constants.tileSize / 4), y: UIScreen.main.bounds.midY, width: 500, height: 500))
        menuBox.zPosition = 2
        menuBox.fillColor = .white
        menuBox.name = MenuBox.pauseLevelMenu.rawValue
        
        let levelMenuLabel: MSButtonNode = MSButtonNode(SKTexture(imageNamed: "level_menu_button"), CGSize(width: menuBox.frame.width / 2, height: menuBox.frame.width / 6), atPosition: CGPoint(x: menuBox.frame.midX, y: menuBox.frame.midY))

        levelMenuLabel.selectedHandler = {
            gameScene.gvc.presentLevelMenu()
        }
        
        menuBox.addChild(levelMenuLabel)
        
        return menuBox
    }
    
    private func getLevelCompleteMenu(for gameScene: GameScene) -> SKShapeNode {
        let menuBox: SKShapeNode = SKShapeNode(rect: CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: 500, height: 500))
        menuBox.zPosition = 2
        menuBox.fillColor = .black
        
        let label: SKLabelNode = SKLabelNode(text: "New Steps: \(gameScene.grid.steps)")
        label.position = CGPoint(x: menuBox.frame.midX, y: menuBox.frame.midY)
        label.fontSize = 50
        label.fontColor = SKColor(displayP3Red: 1.0, green: 0.3, blue: 0.3, alpha: 1.0)
        label.fontName = "PingFangSC-Semibold"
        
        for i in 1..<5 {
            let outline: SKLabelNode = SKLabelNode(text: label.text)
            outline.text = label.text
            outline.fontSize = 50
            outline.fontColor = .white
            outline.fontName = "PingFangSC-Semibold"

            let offAmt: CGFloat = 2
            
            if (i==1) {
                outline.position = CGPoint(x: menuBox.frame.midX - offAmt, y: menuBox.frame.midY + offAmt);
            }
            
            if (i==2) {
                outline.position = CGPoint(x: menuBox.frame.midX + offAmt, y: menuBox.frame.midY + offAmt);
            }
                
            if (i==3) {
                outline.position = CGPoint(x: menuBox.frame.midX - offAmt, y: menuBox.frame.midY - offAmt);
            }
                
            if (i==4) {
                outline.position = CGPoint(x: menuBox.frame.midX + offAmt, y: menuBox.frame.midY - offAmt);
            }
            
            menuBox.addChild(outline)
        }
        
        menuBox.addChild(label)
        
        return menuBox
    }
    
}
