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
    var gameScene: GameScene
    
    init(for gameScene: GameScene) {
        self.gameScene = gameScene
    }
    
    func getBox(ofType type: MenuBox) -> SKShapeNode {
        switch (type) {
            case .pauseLevelMenu:
                return getPauseLevelMenu()
            case .levelCompleteMenu:
                return getLevelCompleteMenu()
            }
    }
    
    private func getCameraPosition() -> CGPoint {
        return self.gameScene.children.first(where: { $0.name == "camera" })!.position
    }
    
    private func getPauseLevelMenu() -> SKShapeNode {
        // Edit node size based on zoom action
        let sizeMultiplier: CGFloat = 1 + abs(1.0 - CGFloat(self.gameScene.grid.grid[0].count) / 8.0)

        let cameraPosition: CGPoint = getCameraPosition()
        let boxLength: CGFloat = 500 * sizeMultiplier
        
        let menuBox: SKShapeNode = SKShapeNode(rect: CGRect(x: cameraPosition.x - boxLength / 2, y: cameraPosition.y - boxLength / 2, width: boxLength, height: boxLength))
        menuBox.zPosition = 2
        menuBox.fillColor = .white
        menuBox.name = MenuBox.pauseLevelMenu.rawValue
        
        let levelMenuLabel: MSButtonNode = MSButtonNode(SKTexture(imageNamed: "level_menu_button"), CGSize(width: menuBox.frame.width / 2, height: menuBox.frame.width / 6), atPosition: CGPoint(x: menuBox.frame.midX, y: menuBox.frame.midY))

        levelMenuLabel.selectedHandler = {
            self.gameScene.gvc.presentLevelMenu()
        }
        
        addRopes(behindBox: menuBox)
        
        menuBox.addChild(levelMenuLabel)
        
        return menuBox
    }
    
    func addRopes(behindBox menuBox: SKShapeNode) {
        let sizeMultiplier: CGFloat = 1 + abs(1.0 - CGFloat(self.gameScene.grid.grid[0].count) / 8.0)

        var rope1: SKSpriteNode = SKSpriteNode(imageNamed: "rope_bit") // Check appearance on iPhone, other devices, zoom
        rope1.position = CGPoint(x: menuBox.frame.midX / 2, y: sizeMultiplier * (UIScreen.main.bounds.maxY + 100) + getCameraPosition().y) // Add 100 for safety
        menuBox.addChild(rope1)
        
        var prevY = rope1.position.y
        
        while rope1.position.y > menuBox.frame.maxY {
            rope1 = SKSpriteNode(imageNamed: "rope_bit")
            rope1.position = CGPoint(x: menuBox.frame.midX / 2, y: prevY - rope1.frame.height)
            prevY = rope1.position.y
            menuBox.addChild(rope1)
        }
        
        var rope2: SKSpriteNode = SKSpriteNode(imageNamed: "rope_bit")
        rope2.position = CGPoint(x: menuBox.frame.midX * 1.5, y: sizeMultiplier * (UIScreen.main.bounds.maxY + 100) + getCameraPosition().y)
        menuBox.addChild(rope2)
        
        prevY = rope2.position.y

        while rope2.position.y > menuBox.frame.maxY {
            rope2 = SKSpriteNode(imageNamed: "rope_bit")
            rope2.position = CGPoint(x: menuBox.frame.midX * 1.5, y: prevY - rope2.frame.height)
            prevY = rope2.position.y
            menuBox.addChild(rope2)
        }

    }
    
    private func getLevelCompleteMenu() -> SKShapeNode {
        // Edit node size based on zoom action
        let sizeMultiplier: CGFloat = 1 + abs(1.0 - CGFloat(self.gameScene.grid.grid[0].count) / 8.0)

        let cameraPosition: CGPoint = getCameraPosition()
        let boxLength: CGFloat = 500 * sizeMultiplier

        let menuBox: SKShapeNode = SKShapeNode(rect: CGRect(x: cameraPosition.x - boxLength / 2, y: cameraPosition.y - boxLength / 2, width: boxLength, height: boxLength))
        menuBox.zPosition = 2
        menuBox.fillColor = .white
        menuBox.name = MenuBox.levelCompleteMenu.rawValue
        
        let oldStepsLabel: StepLabel = StepLabel(withText: "Old Steps: \(gameScene.grid.lowestSteps)", at: CGPoint(x: menuBox.frame.midX, y: menuBox.frame.midY + 50))
        let newStepsLabel: StepLabel = StepLabel(withText: "New Steps: \(gameScene.grid.currentSteps)", at: CGPoint(x: menuBox.frame.midX, y: menuBox.frame.midY - 50))
        
        if gameScene.grid.lowestSteps != Int32.max { menuBox.addChild(oldStepsLabel) }
        menuBox.addChild(newStepsLabel)
        
        let buttonRestart: MSButtonNode = MSButtonNode(SKTexture(imageNamed: "reset_button"), CGSize(width: 80, height: 80), atPosition: CGPoint(x: menuBox.frame.minX + 50, y: menuBox.frame.minY + 50))
        
        buttonRestart.selectedHandler = {
            self.gameScene.gvc.loadLevel(number: CoreDataManager.gameSceneClass.level)
        }
        
        // Remove next button if there is no next level
        let buttonNext: MSButtonNode = MSButtonNode(SKTexture(imageNamed: "next_button"), CGSize(width: 80, height: 80), atPosition: CGPoint(x: menuBox.frame.minX + 150, y: menuBox.frame.minY + 50))

        buttonNext.selectedHandler = {
            self.gameScene.goToNextLevel()
        }
        
        menuBox.addChild(buttonRestart)
        if CoreDataManager.gameSceneClass.level != Constants().numLevels { menuBox.addChild(buttonNext) }

        return menuBox
    }
    
}
