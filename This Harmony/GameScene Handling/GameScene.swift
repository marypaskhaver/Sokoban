//
//  GameScene.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 12/29/20.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var grid: Grid!
    // Can add vars holding "floorType" and "wallType" to change the images of floors and walls if there are multiple kinds of floors and walls;
    // this means that every level will have the same floor and same walls across that whole level, though diff. levels can have diff. floors and walls
    
    var buttonRestart: MSButtonNode! // Create these in every scene w/ code so they don't repeat in the scene editor
    var buttonNext: MSButtonNode!
    var buttonPrevious: MSButtonNode!
    var buttonMenu: MSButtonNode!

    var levelLabel: TextLabel!
    var stepsLabel: TextLabel!
    
    static var level: Int = 1
    
    var gvc: GameViewController!
    var buttonAndLabelMaker: GameSceneButtonAndLabelMaker!

    var trackers: [SwipeTracker] = []
    
    lazy var theme: Theme = Constants().levelThemes[GameScene.level]!

    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        // Create grid
        let gridCreator: GridCreator = GridCreator(withChildren: children)
        grid = Grid(with2DArrayOfTiles: gridCreator.grid, laserPointers: gridCreator.laserPointers, withCoreDataManager: gvc.cdm)
        
        let childrenToAdd: [Tile : CGPoint] = gridCreator.childrenToAddToView
        
        for child in childrenToAdd.keys { // These will always be Floors to add underneath players and crates bc there will always be a player and some crates
            child.position = childrenToAdd[child]!
            self.addChild(child)
        }
                
        // Set buttons-- change from hardcoded to based off screen size later
        buttonAndLabelMaker = GameSceneButtonAndLabelMaker(with: self)
        buttonAndLabelMaker.addButtonsAndLabels()
        disableButtonsIfNeeded()
        
        // Set up trackers to track UISwipeGestureRecognizers and move character, update grid when swipe occurs
        trackers = [SwipeRightTracker(for: self), SwipeLeftTracker(for: self), SwipeUpTracker(for: self), SwipeDownTracker(for: self)]
    }
    
    // Load level
    class func getLevel(_ levelNumber: Int) -> GameScene? {
        guard let scene = GameScene(fileNamed: "Level_\(levelNumber)") else {
            return nil
        }
                
        scene.scaleMode = .aspectFill
        return scene
    }
    
    func disableButtonsIfNeeded() {
        // Disable buttons if needed
        if GameScene.getLevel(GameScene.level + 1) == nil {
            buttonNext.state = .disabled
            buttonNext.reloadInputViews()
        } else if GameScene.getLevel(GameScene.level - 1) == nil {
            buttonPrevious.state = .disabled
            buttonPrevious.reloadInputViews()
        }
    }
    
    func disableSwipeTrackers() {
        _ = self.view!.gestureRecognizers?.map( { $0.isEnabled = false } )
    }
    
    func goToNextLevel() {
        let nextLevel: GameScene? = GameScene.getLevel(GameScene.level + 1)
        
        if nextLevel != nil {
            nextLevel!.gvc = gvc
            GameScene.level += 1
            self.view?.presentScene(nextLevel)
        }
        
        disableButtonsIfNeeded()
    }
    
    func goToPreviousLevel() {
        let previousLevel: GameScene? = GameScene.getLevel(GameScene.level - 1)
        
        if previousLevel != nil {
            previousLevel!.gvc = gvc
            GameScene.level -= 1
            self.view?.presentScene(previousLevel)
        }

        disableButtonsIfNeeded()
    }
    
    func showPauseAndSettingsMenu() {
        let menuBox: SKShapeNode = MenuBoxMaker().getBox(ofType: .pauseLevelMenu, for: self)
                
        // Filter scene's children for any nodes w/ the name "pause-level-menu"
        let nodesNamedMenuBox: [SKNode] = children.filter { (node) -> Bool in
            node.name == MenuBox.pauseLevelMenu.rawValue
        }
        
        if nodesNamedMenuBox.count == 0 {
            self.scene?.addChild(menuBox)
        }
        
        disableSwipeTrackers() // So user can't move while menu is open
    }
    
    func showLevelCompleteMenu() {
        let menuBox: SKShapeNode = MenuBoxMaker().getBox(ofType: .levelCompleteMenu, for: self)
        self.scene?.addChild(menuBox)
        
        buttonRestart.state = .disabled
        buttonNext.state = .disabled
        buttonPrevious.state = .disabled
        
        grid.updateStepDataIfNeeded()
        
        disableSwipeTrackers() // So user can't move while menu is open
    }
    
}
