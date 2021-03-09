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
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        // Create grid
        let gridCreator: GridCreator = GridCreator(withChildren: children)
        grid = Grid(with2DArrayOfTiles: gridCreator.grid, laserPointers: gridCreator.laserPointers)
        
        let childrenToAdd: [Tile : CGPoint] = gridCreator.childrenToAddToView
        
        for child in childrenToAdd.keys { // These will always be Floors to add underneath players and crates bc there will always be a player and some crates
            child.position = childrenToAdd[child]!
            self.addChild(child)
        }
                
        // Set buttons-- change from hardcoded to based off screen size later
        buttonAndLabelMaker = GameSceneButtonAndLabelMaker(with: self)
        buttonAndLabelMaker.addButtonsAndLabels()
        disableButtonsIfNeeded()
                
        let swipeRight: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedRight(sender:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)

        let swipeLeft: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedLeft(sender:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)

        let swipeUp: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedUp(sender:)))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)

        let swipeDown: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedDown(sender:)))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
    }
        
    @objc func swipedRight(sender: UISwipeGestureRecognizer) {
        grid?.movePlayer(inDirection: .right)
        stepsLabel.text = "Steps: \(grid.steps)"
    }
    
    @objc func swipedLeft(sender: UISwipeGestureRecognizer) {
        grid?.movePlayer(inDirection: .left)
        stepsLabel.text = "Steps: \(grid.steps)"
    }
    
    @objc func swipedUp(sender: UISwipeGestureRecognizer) {
        grid?.movePlayer(inDirection: .up)
        stepsLabel.text = "Steps: \(grid.steps)"
    }
    
    @objc func swipedDown(sender: UISwipeGestureRecognizer) {
        grid?.movePlayer(inDirection: .down)
        stepsLabel.text = "Steps: \(grid.steps)"
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
    
    func goToNextLevel() {
        let nextLevel: GameScene? = GameScene.getLevel(GameScene.level + 1)
        
        if nextLevel != nil {
            GameScene.level += 1
            self.view?.presentScene(nextLevel)
        }
        
        disableButtonsIfNeeded()
    }
    
    func goToPreviousLevel() {
        let previousLevel: GameScene? = GameScene.getLevel(GameScene.level - 1)
        
        if previousLevel != nil {
            GameScene.level -= 1
            self.view?.presentScene(previousLevel)
        }

        disableButtonsIfNeeded()
    }
    
    func showPauseAndSettingsMenu() {
        let menuBox: SKShapeNode = SKShapeNode(rect: CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: 500, height: 700))
        menuBox.zPosition = 2
        menuBox.fillColor = .white
        menuBox.name = "menu-box"

        let levelMenuLabel: MSButtonNode = MSButtonNode(SKTexture(imageNamed: "level_menu_button"), CGSize(width: 200, height: 100), atPosition: CGPoint(x: menuBox.frame.midX, y: menuBox.frame.midY))

        levelMenuLabel.selectedHandler = {
            self.gvc.presentLevelMenu()
        }

        menuBox.addChild(levelMenuLabel)
                
        // Filter scene's children for any nodes w/ the name "menu-box"
        let nodesNamedMenuBox: [SKNode] = children.filter { (node) -> Bool in
            node.name == "menu-box"
        }
        
        if nodesNamedMenuBox.count == 0 {
            self.scene?.addChild(menuBox)
        }
    }
    
}
