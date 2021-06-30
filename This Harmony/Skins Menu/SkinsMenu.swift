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
    
    lazy var instructionsLabel: SKLabelNode = self.childNode(withName: "instructions") as! SKLabelNode
    
    override func didMove(to view: SKView) {
        imageInd = getIndexOfUserChosenImage() >= 1 ? getIndexOfUserChosenImage() : 0
        
        if imageInd >= 1 {
            self.playerImageLeft.texture = SKTexture(imageNamed: self.images[imageInd - 1] + "_d_stand")
            self.playerImage.texture = SKTexture(imageNamed: self.images[imageInd] + "_d_stand")
            self.playerImageRight.texture = SKTexture(imageNamed: self.images[imageInd + 1] + "_d_stand")
        } else {
            // Don't set left image bc when view loads, start at imageInd 0
            self.playerImage.texture = SKTexture(imageNamed: self.images[imageInd] + "_d_stand")
            self.playerImageRight.texture = SKTexture(imageNamed: self.images[imageInd + 1] + "_d_stand")
        }
                        
        self.playerImageLeft.selectedHandler = {
            self.shiftPlayerImages(to: .left)
        }
        
        self.playerImageRight.selectedHandler = {
            self.shiftPlayerImages(to: .right)
        }
        
        setUpLabels()
        setButtonHandlers()
        
        updateButtonsAndImages()
        updateNameLabel()
    }
    
    func getIndexOfUserChosenImage() -> Int {
        if let currentImage = defaults.string(forKey: "userChosenPlayerImage") {
            return images.firstIndex(of: currentImage)!
        }
        
        return -1
    }
    
    func setUpLabels() {
        // Set nameLabel font properties
        nameLabel.fontName = "PlayMeGames"
        nameLabel.fontSize = 60
        
        // Set instructionsLabel font properties
        instructionsLabel.text = "   Swipe or tap a sprite\n\t\t  to change skins"
        instructionsLabel.fontName = "Pixellium"
        instructionsLabel.fontSize = 45
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
    
    func removeSprite(_ sprite: SKSpriteNode) {
        sprite.removeFromParent()
    }
    
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
        if !instructionsLabel.isHidden {
            instructionsLabel.run(SKAction.fadeOut(withDuration: 1))
        }
        
        // Hide playerImage. Will be unhidden in animateImageSwitch funcs.
        playerImage.isHidden = true
        
        if dir == .right {
            animateImageSwitchLeft(from: playerImage, to: playerImageLeft)
            animateImageSwitchLeft(from: playerImageRight, to: playerImage)

            if self.imageInd + 1 < self.images.count {
                self.playerImage.texture = SKTexture(imageNamed: self.images[self.imageInd + 1] + "_d_stand")
                self.imageInd += 1
            }

            self.updateButtonsAndImages()
            self.updateNameLabel()
        } else if dir == .left {
            animateImageSwitchRight(from: playerImageLeft, to: playerImage)
            animateImageSwitchRight(from: playerImage, to: playerImageRight)

            if self.imageInd - 1 >= 0 {
                self.playerImage.texture = SKTexture(imageNamed: self.images[self.imageInd - 1] + "_d_stand")
                self.imageInd -= 1
            }

            self.updateButtonsAndImages()
            self.updateNameLabel()
        }
    }
        
    func animateImageSwitchLeft(from rightmostImage: SKSpriteNode, to leftmostImage: SKSpriteNode) {
        if playerImageRight.isHidden { return }
                        
        let playerImageCopy: SKSpriteNode = SKSpriteNode(texture: rightmostImage.texture)
        playerImageCopy.position = CGPoint(x: rightmostImage.frame.midX, y: rightmostImage.frame.midY)
        playerImageCopy.scale(to: leftmostImage.size)
        
        self.addChild(playerImageCopy)
                
        let move: SKAction = SKAction.move(to: CGPoint(x: leftmostImage.frame.midX, y: leftmostImage.frame.midY), duration: 0.2)
        let scale: SKAction = SKAction.scale(to: leftmostImage.frame.size, duration: 0.2)

        playerImageCopy.run(SKAction.group([move, scale]))

        let wait: SKAction = SKAction.wait(forDuration: 0.3)
        let remove: SKAction = SKAction.run({() in self.removeSprite(playerImageCopy)})
        let unhidePlayerImage: SKAction = SKAction.run({() in self.unhidePlayerImage()})
        
        playerImageCopy.run(SKAction.sequence([wait, remove, unhidePlayerImage]))
    }
    
    func unhidePlayerImage() {
        playerImage.isHidden = false
    }
    
    func animateImageSwitchRight(from leftmostImage: SKSpriteNode, to rightmostImage: SKSpriteNode) {
        if playerImageLeft.isHidden { return }

        let playerImageCopy: SKSpriteNode = SKSpriteNode(texture: leftmostImage.texture)
        playerImageCopy.position = CGPoint(x: leftmostImage.frame.midX, y: leftmostImage.frame.midY)
        playerImageCopy.scale(to: leftmostImage.size)
        
        self.addChild(playerImageCopy)
        
        let move: SKAction = SKAction.move(to: CGPoint(x: rightmostImage.frame.midX, y: rightmostImage.frame.midY), duration: 0.2)
        let scale: SKAction = SKAction.scale(to: rightmostImage.frame.size, duration: 0.2)

        playerImageCopy.run(SKAction.group([move, scale]))

        let wait: SKAction = SKAction.wait(forDuration: 0.3)
        let remove: SKAction = SKAction.run({() in self.removeSprite(playerImageCopy)})
        let unhidePlayerImage: SKAction = SKAction.run({() in self.unhidePlayerImage()})
        
        playerImageCopy.run(SKAction.sequence([wait, remove, unhidePlayerImage]))
    }
    
}
