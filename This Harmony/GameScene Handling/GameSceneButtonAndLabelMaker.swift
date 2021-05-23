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
        
        let gc1: GameScene = GameScene.getLevel(1)!
        let gridCreator: GridCreator = GridCreator(withChildren: gc1.children)
        let grid = Grid(with2DArrayOfTiles: gridCreator.grid, laserPointers: gridCreator.laserPointers, withCoreDataManager: CoreDataManager())

        // Camera is always set up before buttons and is the center of the grid
        let cameraPosition: CGPoint = gc.children.first(where: {$0.name == "camera"})!.position
        
        let vector: CGVector = CGVector(dx: UIScreen.main.bounds.maxX / 2 - cameraPosition.x, dy: UIScreen.main.bounds.maxY / 2 - cameraPosition.y)
        
        // Zoom camera so each grid takes up same amt of space. Based off # columns-- how to address rows?
        let zoomInAction = SKAction.scale(to: CGFloat(gc.grid.grid[0].count) / 8.0, duration: 0)
        gc.children.first(where: {$0.name == "camera"})!.run(zoomInAction)

        // Edit node size based on zoom action
        let sizeMultiplier: CGFloat = 1 + abs(1.0 - CGFloat(gc.grid.grid[0].count) / 8.0)
        
        let buttonSize = CGSize(width: 80 * sizeMultiplier, height: 80 * sizeMultiplier)
            
        let positionBeforeApplyingVector: CGFloat = grid.grid[grid.grid.count - 1][0].frame.midY * sizeMultiplier - 0.35 * sizeMultiplier * UIScreen.main.bounds.height * sizeMultiplier
        let tileShift: CGFloat = abs(1 - sizeMultiplier) * CGFloat(Tile.constants.tileSize)
    
        let buttonPrevious: MSButtonNode = MSButtonNode(SKTexture(imageNamed: "prev_button"), buttonSize, atPosition: CGPoint(x: grid.grid[0][0].frame.midX * sizeMultiplier / 2, y: positionBeforeApplyingVector - (75 * sizeMultiplier + vector.dy * sizeMultiplier) - tileShift))
                
        // 75 won't work for all hardcoding-- what about diff phone sizes, iPads?
        
        let buttonNext: MSButtonNode = MSButtonNode(SKTexture(imageNamed: "next_button"), buttonSize, atPosition: CGPoint(x: buttonPrevious.position.x + 90 * sizeMultiplier, y: buttonPrevious.frame.midY))

        let buttonRestart: MSButtonNode = MSButtonNode(SKTexture(imageNamed: "reset_button"), buttonSize, atPosition: CGPoint(x: buttonNext.position.x + 90 * sizeMultiplier, y: buttonPrevious.frame.midY))

        let buttonMenu: MSButtonNode = MSButtonNode(SKTexture(imageNamed: "menu_button"), CGSize(width: 60 * sizeMultiplier, height: 60 * sizeMultiplier), atPosition: CGPoint(x: buttonPrevious.frame.midX - 20 * sizeMultiplier, y: grid.grid[0][0].frame.midY * sizeMultiplier + 80 * sizeMultiplier - sizeMultiplier * (75 + vector.dy) - 4 * tileShift))

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
        gc.levelLabel.setScale(sizeMultiplier)
        
        gc.stepsLabel = TextLabel("Steps: \(gc.grid.currentSteps)", at: CGPoint(x: cameraPosition.x, y: (gc.grid.grid[gc.grid.grid.count - 1][0].frame.midY + (gc.buttonRestart.frame.midY)) / 2))
        gc.stepsLabel.setScale(sizeMultiplier)
        
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
