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
        menuBox.fillColor = .white
        
        let oldStepsLabel: StepLabel = StepLabel(withText: "Old Steps: \(gameScene.grid.oldSteps)", at: CGPoint(x: menuBox.frame.midX, y: menuBox.frame.midY + 50))
        let newStepsLabel: StepLabel = StepLabel(withText: "New Steps: \(gameScene.grid.steps)", at: CGPoint(x: menuBox.frame.midX, y: menuBox.frame.midY - 50))
        
        menuBox.addChild(oldStepsLabel)
        menuBox.addChild(newStepsLabel)
        
        let buttonRestart: MSButtonNode = MSButtonNode(SKTexture(imageNamed: "reset_button"), CGSize(width: 80, height: 80), atPosition: CGPoint(x: menuBox.frame.minX + 50, y: menuBox.frame.minY + 50))
        buttonRestart.selectedHandler = {
            gameScene.gvc.loadLevel(number: GameScene.level)
        }
        
        menuBox.addChild(buttonRestart)
        
                
        return menuBox
    }
    
}
