//
//  GameSceneButtonAndLabelMaker.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 3/3/21.
//

import Foundation
import SpriteKit

class GameSceneButtonAndLabelMaker {
    var gc: GameScene!
    
    init(with gc: GameScene) {
        self.gc = gc
    }
    
    func addButtonsAndLabels() {
        let buttonRestart: MSButtonNode = MSButtonNode(SKTexture(imageNamed: "reset_button"), CGSize(width: 80, height: 80), atPosition: CGPoint(x: 384, y: 60))
        let buttonNext: MSButtonNode = MSButtonNode(SKTexture(imageNamed: "next_button"), CGSize(width: 80, height: 80), atPosition: CGPoint(x: 200, y: 60))
        let buttonPrevious: MSButtonNode = MSButtonNode(SKTexture(imageNamed: "prev_button"), CGSize(width: 80, height: 80), atPosition: CGPoint(x: 100, y: 60))
        let buttonMenu: MSButtonNode = MSButtonNode(SKTexture(imageNamed: "menu_button"), CGSize(width: 60, height: 60), atPosition: CGPoint(x: 80, y: 970))
        
        buttonRestart.name = "reset_button"
        buttonNext.name = "next_button"
        buttonPrevious.name = "prev_button"
        buttonMenu.name = "menu_button"
        
        gc.buttonRestart = buttonRestart
        gc.buttonNext = buttonNext
        gc.buttonPrevious = buttonPrevious
        gc.buttonMenu = buttonMenu
        
        gc.levelLabel = TextLabel("Level \(CoreDataManager.gameSceneClass.level)", at: CGPoint(x: 384, y: 970))
        gc.stepsLabel = TextLabel("Steps: \(gc.grid.currentSteps)", at: CGPoint(x: 384, y: 150))
        
        setButtonHandlers()
        addButtonsAndLabelsToSceneChildren()
    }
    
    private func setButtonHandlers() {
        gc.buttonRestart.selectedHandler = {
            self.gc.gvc.loadLevel(number: CoreDataManager.gameSceneClass.level)
        }
        
        gc.buttonNext.selectedHandler = {
            self.gc.goToNextLevel()
        }
        
        gc.buttonPrevious.selectedHandler = {
            self.gc.goToPreviousLevel()
        }
        
        gc.buttonMenu.selectedHandler = {
            self.gc.showPauseAndSettingsMenu()
        }
    }
    
    private func addButtonsAndLabelsToSceneChildren() {
        gc.addChild(gc.buttonRestart)
        gc.addChild(gc.buttonNext)
        gc.addChild(gc.buttonPrevious)
        gc.addChild(gc.buttonMenu)
        gc.addChild(gc.levelLabel)
        gc.addChild(gc.stepsLabel)
    }
}
