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
        
        let buttonRestart: MSButtonNode = MSButtonNode(SKTexture(imageNamed: "reset_button"), CGSize(width: 80, height: 80), atPosition: CGPoint(x: cameraPosition.x - (UIScreen.main.bounds.width - 160) / 2, y: cameraPosition.y - UIScreen.main.bounds.height + 20))
        
        let buttonNext: MSButtonNode = MSButtonNode(SKTexture(imageNamed: "next_button"), CGSize(width: 80, height: 80), atPosition: CGPoint(x: buttonRestart.position.x - 100, y: buttonRestart.position.y))
        
        let buttonPrevious: MSButtonNode = MSButtonNode(SKTexture(imageNamed: "prev_button"), CGSize(width: 80, height: 80), atPosition: CGPoint(x: buttonNext.position.x - 100, y: buttonRestart.position.y))
        
        let buttonMenu: MSButtonNode = MSButtonNode(SKTexture(imageNamed: "menu_button"), CGSize(width: 60, height: 60), atPosition: CGPoint(x: buttonPrevious.frame.minX + 30, y: cameraPosition.y + UIScreen.main.bounds.height - 20))
        
        buttonRestart.name = "reset_button"
        buttonNext.name = "next_button"
        buttonPrevious.name = "prev_button"
        buttonMenu.name = "menu_button"
        
        gc.buttonRestart = buttonRestart
        gc.buttonNext = buttonNext
        gc.buttonPrevious = buttonPrevious
        gc.buttonMenu = buttonMenu
        
        gc.levelLabel = TextLabel("Level \(CoreDataManager.gameSceneClass.level)", at: CGPoint(x: cameraPosition.x, y: cameraPosition.y + 0.9 * UIScreen.main.bounds.height))
        gc.stepsLabel = TextLabel("Steps: \(gc.grid.currentSteps)", at: CGPoint(x: cameraPosition.x, y: cameraPosition.y - 0.75 * UIScreen.main.bounds.height))
        
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
