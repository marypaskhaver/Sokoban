//
//  GameSceneButtonAndLabelMaker.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 3/3/21.
//

import Foundation
import SpriteKit

class GameSceneButtonAndLabelMaker {
    static func addButtonsAndLabels(toGameScene gc: GameScene) {
        let buttonRestart: MSButtonNode = MSButtonNode(SKTexture(imageNamed: "reset_button"), CGSize(width: 80, height: 80), atPosition: CGPoint(x: 384, y: 60))
        let buttonNext: MSButtonNode = MSButtonNode(SKTexture(imageNamed: "next_button"), CGSize(width: 80, height: 80), atPosition: CGPoint(x: 200, y: 60))
        let buttonPrevious: MSButtonNode = MSButtonNode(SKTexture(imageNamed: "prev_button"), CGSize(width: 80, height: 80), atPosition: CGPoint(x: 100, y: 60))
        let buttonMenu: MSButtonNode = MSButtonNode(SKTexture(imageNamed: "menu_button"), CGSize(width: 60, height: 60), atPosition: CGPoint(x: 80, y: 970))

        buttonRestart.selectedHandler = {
            gc.gvc.loadLevel(number: GameScene.level)
        }
        
        buttonNext.selectedHandler = {
            gc.goToNextLevel()
        }
        
        buttonPrevious.selectedHandler = {
            gc.goToPreviousLevel()
        }
        
        buttonMenu.selectedHandler = {
            gc.showPauseAndSettingsMenu()
        }
        
        gc.levelLabel = TextLabel("Level \(GameScene.level)", at: CGPoint(x: 384, y: 970))
        gc.stepsLabel = TextLabel("Steps: \(gc.grid.steps)", at: CGPoint(x: 384, y: 150))
        
        gc.buttonRestart = buttonRestart
        gc.buttonNext = buttonNext
        gc.buttonPrevious = buttonPrevious
        gc.buttonMenu = buttonMenu

        gc.addChild(gc.buttonRestart)
        gc.addChild(gc.buttonNext)
        gc.addChild(gc.buttonPrevious)
        gc.addChild(gc.buttonMenu)
        gc.addChild(gc.levelLabel)
        gc.addChild(gc.stepsLabel)
    }
}
