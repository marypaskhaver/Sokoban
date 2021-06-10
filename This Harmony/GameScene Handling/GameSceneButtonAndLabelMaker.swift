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
        
        let vector: CGVector = CGVector(dx: UIScreen.main.bounds.maxX / 2 - cameraPosition.x, dy: UIScreen.main.bounds.maxY / 2 - cameraPosition.y)
        
        // Zoom camera so each grid takes up same amt of space. Based off # columns-- how to address rows?
        let zoomInAction = SKAction.scale(to: CGFloat(gc.grid.grid[0].count) / 8.0, duration: 0)
        gc.children.first(where: {$0.name == "camera"})!.run(zoomInAction)

        // Edit node size based on zoom action
        let currentWidthRatioToIdealWidth: CGFloat = CGFloat(gc.grid.grid[0].count) / 8.0
        
        let sizeMultiplier: CGFloat = currentWidthRatioToIdealWidth < 1 ? currentWidthRatioToIdealWidth : 1 + abs(1.0 - CGFloat(gc.grid.grid[0].count) / 8.0)
                    
        var positionBeforeApplyingVector: CGFloat {
            // Tile.constants.tileSize / 2 gives midY of bottom left-most node, at (35, 35)
            let bottomLeftMidY: CGFloat = CGFloat(Tile.constants.tileSize / 2)

            switch UIDevice.current.userInterfaceIdiom {

            case .phone:
                return bottomLeftMidY * sizeMultiplier - 0.35 * sizeMultiplier * UIScreen.main.bounds.height * sizeMultiplier
            case .pad:
                return bottomLeftMidY * sizeMultiplier - 0.35 * sizeMultiplier * UIScreen.main.bounds.height * sizeMultiplier
            default:
                return -1
            }
        }
        
        
        var tileShift: CGFloat = abs(1 - sizeMultiplier) * CGFloat(Tile.constants.tileSize)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            tileShift = 2.4 * -tileShift
        }
        
        var moveDownAmt: CGFloat {
            switch UIDevice.current.userInterfaceIdiom {
            case .phone:
                return 75
            case .pad:
                return -390
            default:
                return -1
            }
        }
        
        let topLeftMidX: CGFloat = CGFloat(Tile.constants.tileSize / 2)
        
        let buttonPrevTexture: SKTexture = SKTexture(imageNamed: "prev_button")

        let buttonPrevious: MSButtonNode = MSButtonNode(withName: "prev_button", SKTexture(imageNamed: "prev_button"), CGSize(width: buttonPrevTexture.size().width / buttonPrevTexture.size().height * 60 * sizeMultiplier, height: 60 * sizeMultiplier), atPosition: CGPoint(x: topLeftMidX * sizeMultiplier, y: positionBeforeApplyingVector - (moveDownAmt * sizeMultiplier + vector.dy * sizeMultiplier) - tileShift))

        let space: CGFloat = buttonPrevious.size.width * 1.2
        
        let buttonNextTexture: SKTexture = SKTexture(imageNamed: "next_button")
        let buttonNext: MSButtonNode = MSButtonNode(withName: "next_button", buttonNextTexture, buttonPrevious.size, atPosition: CGPoint(x: buttonPrevious.position.x + space * sizeMultiplier, y: buttonPrevious.frame.midY))
                
        let buttonRestart: MSButtonNode = MSButtonNode(withName: "reset_button", SKTexture(imageNamed: "reset_button"), buttonNext.size, atPosition: CGPoint(x: buttonNext.position.x + space * sizeMultiplier, y: buttonPrevious.frame.midY))
        
        var moveDownAmt2: CGFloat {
            switch UIDevice.current.userInterfaceIdiom {
            case .phone:
                if tileShift == 0 {
                    return 75
                } else {
                    return 2.4 * CGFloat(Tile.constants.tileSize)
                }
                
            case .pad:
                if tileShift == 0 {
                    return -200
                } else {
                    return -1.25 * CGFloat(Tile.constants.tileSize)
                }
                    
            default:
                return -1
            }
        }
        
        let finalMoveDown: CGFloat = sizeMultiplier == 1 ? 0 : -70
        
        let topLeftMidY: CGFloat = CGFloat(Tile.constants.tileSize / 2) + CGFloat(Tile.constants.tileSize) * 9

        let buttonMenu: MSButtonNode = MSButtonNode(withName: "menu_button", SKTexture(imageNamed: "menu_button"), CGSize(width: 60 * sizeMultiplier, height: 60 * sizeMultiplier), atPosition: CGPoint(x: buttonPrevious.frame.midX - 20 * sizeMultiplier, y: topLeftMidY * sizeMultiplier + 80 * sizeMultiplier - sizeMultiplier * (moveDownAmt2 + vector.dy) - finalMoveDown))

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
