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

    lazy var buttonNext: MSButtonNode = self.childNode(withName: "buttonNext") as! MSButtonNode
    lazy var buttonPrev: MSButtonNode = self.childNode(withName: "buttonPrevious") as! MSButtonNode
    
    lazy var playerImage: SKSpriteNode = self.childNode(withName: "playerImage") as! SKSpriteNode
    
    lazy var buttonDone: MSButtonNode = self.childNode(withName: "buttonDone") as! MSButtonNode
    
    var gvc: GameViewController!

    var images: [String] = ["louise", "delia", "aaron", "marco"]
    var imageInd: Int = 0

    lazy var nameLabel: SKLabelNode = self.childNode(withName: "nameLabel") as! SKLabelNode

    lazy var playerImageLeft: SKSpriteNode = self.childNode(withName: "playerImageLeft") as! SKSpriteNode
    lazy var playerImageRight: SKSpriteNode = self.childNode(withName: "playerImageRight") as! SKSpriteNode
    
    override func didMove(to view: SKView) {
        // Don't set left image bc when view loads, start at imageInd 0
        self.playerImage.texture = SKTexture(imageNamed: self.images[imageInd] + "_d_stand")
        self.playerImageRight.texture = SKTexture(imageNamed: self.images[imageInd + 1] + "_d_stand")
        
        setUpNameLabel()
        setButtonHandlers()
        
        updateButtons()
        updateNameLabel()
    }
    
    func setUpNameLabel() {
        // Set nameLabel font properties
        nameLabel.fontName = "PlayMeGames"
        nameLabel.fontSize = 60
    }
    
    func setButtonHandlers() {
        buttonPrev.selectedHandler = {
            if self.imageInd - 1 >= 0 {
                self.playerImage.texture = SKTexture(imageNamed: self.images[self.imageInd - 1] + "_d_stand")
                self.imageInd -= 1
            }
            
            self.updateButtons()
            self.updateNameLabel()
        }
                
        buttonNext.selectedHandler = {
            if self.imageInd + 1 < self.images.count {
                self.playerImage.texture = SKTexture(imageNamed: self.images[self.imageInd + 1] + "_d_stand")
                self.imageInd += 1
            }

            self.updateButtons()
            self.updateNameLabel()
        }
                
        buttonDone.selectedHandler = {
            defaults.setValue(self.images[self.imageInd], forKey: "userChosenPlayerImage")
            self.gvc.presentMainMenu()
        }
    }
    
    func updateButtons() {
        if imageInd == 0 {
            buttonPrev.isHidden = true
            playerImageLeft.isHidden = true
        } else if imageInd == images.count - 1 {
            buttonNext.isHidden = true
            playerImageRight.isHidden = true
        } else {
            buttonNext.isHidden = false
            buttonPrev.isHidden = false
            playerImageLeft.isHidden = false
            playerImageRight.isHidden = false
        }
        
        updatePlayerLeftAndRightImages()
        
        playerImageLeft.reloadInputViews()
        playerImageRight.reloadInputViews()
        buttonNext.reloadInputViews()
        buttonPrev.reloadInputViews()
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
    
}
