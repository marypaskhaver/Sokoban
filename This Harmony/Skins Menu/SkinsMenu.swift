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

    var buttonNext: MSButtonNode!
    var buttonPrev: MSButtonNode!
    
    var playerImage: SKSpriteNode!
    
    var buttonDone: MSButtonNode!
    
    var gvc: GameViewController!

    var images: [String] = ["louise", "delia", "aaron", "marco"]
    var imageInd: Int = 0

    var nameLabel: SKLabelNode!

    var playerImageLeft: SKSpriteNode!
    var playerImageRight: SKSpriteNode!
    
    override func didMove(to view: SKView) {

        playerImage = self.childNode(withName: "playerImage") as! SKSpriteNode
        playerImageLeft = self.childNode(withName: "playerImageLeft") as! SKSpriteNode
        playerImageRight = self.childNode(withName: "playerImageRight") as! SKSpriteNode

        // Don't set left image bc when view loads, start at imageInd 0
        self.playerImage.texture = SKTexture(imageNamed: self.images[imageInd] + "_d_stand")
        self.playerImageRight.texture = SKTexture(imageNamed: self.images[imageInd + 1] + "_d_stand")

        // Set UI connections
        nameLabel = self.childNode(withName: "nameLabel") as! SKLabelNode
        nameLabel.fontName = "PlayMeGames"
        nameLabel.fontSize = 60
        
        // Set UI connections
        buttonPrev = self.childNode(withName: "buttonPrevious") as! MSButtonNode

        buttonPrev.selectedHandler = {
            if self.imageInd - 1 >= 0 {
                self.playerImage.texture = SKTexture(imageNamed: self.images[self.imageInd - 1] + "_d_stand")
                self.imageInd -= 1
            }
            
            self.updateButtons()
            self.updateNameLabel()
        }
        
        buttonNext = self.childNode(withName: "buttonNext") as! MSButtonNode
        
        buttonNext.selectedHandler = {
            if self.imageInd + 1 < self.images.count {
                self.playerImage.texture = SKTexture(imageNamed: self.images[self.imageInd + 1] + "_d_stand")
                self.imageInd += 1
            }

            self.updateButtons()
            self.updateNameLabel()
        }
        
        buttonDone = self.childNode(withName: "buttonDone") as! MSButtonNode
        
        buttonDone.selectedHandler = {
            defaults.setValue(self.images[self.imageInd], forKey: "userChosenPlayerImage")
            self.gvc.presentMainMenu()
        }
        
        updateButtons()
        updateNameLabel()
    }
    
    func updateButtons() {
        print("current index: \(imageInd)")
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
        
        if imageInd - 1 >= 0 {
            playerImageLeft.texture = SKTexture(imageNamed: self.images[imageInd - 1] + "_d_stand")
        }
        
        if imageInd + 1 < images.count {
            playerImageRight.texture = SKTexture(imageNamed: self.images[imageInd + 1] + "_d_stand")
        }
        
        playerImageLeft.reloadInputViews()
        playerImageRight.reloadInputViews()
        buttonNext.reloadInputViews()
        buttonPrev.reloadInputViews()
    }
    
    func updateNameLabel() {
        nameLabel.text = images[imageInd].capitalized
    }
    
}
