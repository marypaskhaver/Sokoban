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
        // Camera is always set up before buttons and is the center of the grid
        let cameraPosition: CGPoint = gc.children.first(where: {$0.name == "camera"})!.position

        let buttonPrevious: MSButtonNode = MSButtonNode(SKTexture(imageNamed: "prev_button"), CGSize(width: 80, height: 80), atPosition: CGPoint(x: cameraPosition.x / 3.75, y: 100))
        
        let buttonNext: MSButtonNode = MSButtonNode(SKTexture(imageNamed: "next_button"), CGSize(width: 80, height: 80), atPosition: CGPoint(x: buttonPrevious.position.x + 90, y: 100))

        let buttonRestart: MSButtonNode = MSButtonNode(SKTexture(imageNamed: "reset_button"), CGSize(width: 80, height: 80), atPosition: CGPoint(x: buttonNext.position.x + 90, y: 100))

        let buttonMenu: MSButtonNode = MSButtonNode(SKTexture(imageNamed: "menu_button"), CGSize(width: 60, height: 60), atPosition: CGPoint(x: buttonPrevious.frame.midX - 20, y: 1000))
        
        buttonRestart.name = "reset_button"
        buttonNext.name = "next_button"
        buttonPrevious.name = "prev_button"
        buttonMenu.name = "menu_button"
        
        gc.buttonRestart = buttonRestart
        gc.buttonNext = buttonNext
        gc.buttonPrevious = buttonPrevious
        gc.buttonMenu = buttonMenu
        
        // Button and label positions screwy on iPads
        gc.levelLabel = TextLabel("Level \(CoreDataManager.gameSceneClass.level)", at: CGPoint(x: cameraPosition.x, y: gc.grid.grid[0][0].frame.midY + 80))
        gc.stepsLabel = TextLabel("Steps: \(gc.grid.currentSteps)", at: CGPoint(x: cameraPosition.x, y: (gc.grid.grid[gc.grid.grid.count - 1][0].frame.midY + (gc.buttonRestart.frame.midY)) / 2))
        
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
