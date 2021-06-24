//
//  SkinsMenu.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 6/11/21.
//

import Foundation
import SpriteKit

let defaults = UserDefaults.standard

class SkinsMenu: SKScene {
    
    lazy var playerImage: SKSpriteNode = self.childNode(withName: "playerImage") as! SKSpriteNode
    
    lazy var buttonDone: MSButtonNode = self.childNode(withName: "buttonDone") as! MSButtonNode
    
    var gvc: GameViewController!

    var images: [String] = ["louise", "delia", "aaron", "marco", "christina", "tyler"]
    var imageInd: Int = 0

    lazy var nameLabel: SKLabelNode = self.childNode(withName: "nameLabel") as! SKLabelNode

    lazy var playerImageLeft: MSButtonNode = self.childNode(withName: "playerImageLeft") as! MSButtonNode
    lazy var playerImageRight: MSButtonNode = self.childNode(withName: "playerImageRight") as! MSButtonNode
    
    override func didMove(to view: SKView) {
        // Don't set left image bc when view loads, start at imageInd 0
        self.playerImage.texture = SKTexture(imageNamed: self.images[imageInd] + "_d_stand")
        self.playerImageRight.texture = SKTexture(imageNamed: self.images[imageInd + 1] + "_d_stand")
        
        self.playerImageLeft.shouldChangeAlpha = false
        self.playerImageRight.shouldChangeAlpha = false
        
        self.playerImageLeft.selectedHandler = {
            self.shiftPlayerImages(to: .left)
        }
        
        self.playerImageRight.selectedHandler = {
            self.shiftPlayerImages(to: .right)
        }
        
        setUpNameLabel()
        setButtonHandlers()
        
        updateButtonsAndImages()
        updateNameLabel()
    }
    
    func setUpNameLabel() {
        // Set nameLabel font properties
        nameLabel.fontName = "PlayMeGames"
        nameLabel.fontSize = 60
    }
    
    func setButtonHandlers() {
        let swipeLeftTracker: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedLeft(sender:)))
        swipeLeftTracker.direction = .left
        
        let swipeRightTracker: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedRight(sender:)))
        swipeRightTracker.direction = .right

        self.view!.addGestureRecognizer(swipeLeftTracker)
        self.view!.addGestureRecognizer(swipeRightTracker)

                
        buttonDone.selectedHandler = {
            defaults.setValue(self.images[self.imageInd], forKey: "userChosenPlayerImage")
            self.gvc.presentMainMenu()
        }
    }
    
    func setIsHiddenProperty(for nodes: [SKNode], to bool: Bool) {
        for node in nodes {
            node.isHidden = bool
        }
    }
    
    func updateButtonsAndImages() {
        // Initially, all buttons and playerImages have an isHidden property of false
        if imageInd == 0 {
            setIsHiddenProperty(for: [playerImageLeft], to: true)
        } else if imageInd == images.count - 1 {
            setIsHiddenProperty(for: [playerImageRight], to: true)
        } else {
            setIsHiddenProperty(for: [playerImageLeft, playerImageRight], to: false)
        }
        
        updatePlayerLeftAndRightImages()
//        reloadInputViewsOfButtonsAndImages()
        
        animatePlayerImage()
    }
    
    func updatePlayerLeftAndRightImages() {
        if imageInd - 1 >= 0 {
            playerImageLeft.texture = SKTexture(imageNamed: self.images[imageInd - 1] + "_d_stand")
        }
        
        if imageInd + 1 < images.count {
            playerImageRight.texture = SKTexture(imageNamed: self.images[imageInd + 1] + "_d_stand")
        }
    }
    
//    func reloadInputViewsOfButtonsAndImages() {
//        for node in [playerImageLeft, playerImageRight] {
//            node.reloadInputViews()
//        }
//    }
    
    func animatePlayerImage() {
        let playerTexture: String = images[imageInd]
        
        let anim = SKAction.animate(with: [
            SKTexture(imageNamed: playerTexture + "_d_1"),
            SKTexture(imageNamed: playerTexture + "_d_stand"),
            SKTexture(imageNamed: playerTexture + "_d_2"),
            SKTexture(imageNamed: playerTexture + "_d_stand")
        ], timePerFrame: 0.2)

        playerImage.run(SKAction.repeatForever(anim))
    }
    
    func updateNameLabel() {
        nameLabel.text = images[imageInd].capitalized
    }
    
    @objc func swipedRight(sender: UISwipeGestureRecognizer) {
        shiftPlayerImages(to: .left)
    }
    
    @objc func swipedLeft(sender: UISwipeGestureRecognizer) {
        shiftPlayerImages(to: .right)
    }
    
    func shiftPlayerImages(to dir: Direction) {
        if dir == .right {
            if self.imageInd + 1 < self.images.count {
                self.playerImage.texture = SKTexture(imageNamed: self.images[self.imageInd + 1] + "_d_stand")
                self.imageInd += 1
            }

            self.updateButtonsAndImages()
            self.updateNameLabel()
        } else if dir == .left {
            if self.imageInd - 1 >= 0 {
                self.playerImage.texture = SKTexture(imageNamed: self.images[self.imageInd - 1] + "_d_stand")
                self.imageInd -= 1
            }

            self.updateButtonsAndImages()
            self.updateNameLabel()
        }
    }
    
}
