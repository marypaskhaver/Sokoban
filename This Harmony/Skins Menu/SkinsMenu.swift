//
//  SkinsMenu.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 6/11/21.
//

import Foundation
import SpriteKit

class SkinsMenu: SKScene {

    var buttonNext: MSButtonNode!
    var buttonPrev: MSButtonNode!
    
    var playerImage: SKSpriteNode!
    
    var buttonDone: MSButtonNode!
    
    var gvc: GameViewController!

    var images: [String] = ["louise", "delia", "redhead_boy", "marco"]
    var imageInd: Int = 0

    override func didMove(to view: SKView) {

        playerImage = self.childNode(withName: "playerImage") as! SKSpriteNode
        self.playerImage.texture = SKTexture(imageNamed: self.images[imageInd] + "_d_stand")

        
        // Set UI connections
        buttonPrev = self.childNode(withName: "buttonPrevious") as! MSButtonNode

        buttonPrev.selectedHandler = {
            if self.imageInd - 1 >= 0 {
                self.playerImage.texture = SKTexture(imageNamed: self.images[self.imageInd - 1] + "_d_stand")
                self.imageInd -= 1
            }
            
            self.updateButtons()
        }
        
        buttonNext = self.childNode(withName: "buttonNext") as! MSButtonNode
        
        buttonNext.selectedHandler = {
            if self.imageInd + 1 < self.images.count {
                self.playerImage.texture = SKTexture(imageNamed: self.images[self.imageInd + 1] + "_d_stand")
                self.imageInd += 1
            }

            self.updateButtons()
        }
        
        buttonDone = self.childNode(withName: "buttonDone") as! MSButtonNode
        
        buttonDone.selectedHandler = {
            self.gvc.presentMainMenu()
        }
        
        updateButtons()
    }
    
    func updateButtons() {
        if imageInd == 0 {
            buttonPrev.isHidden = true
        } else if imageInd == images.count - 1 {
            buttonNext.isHidden = true
        } else {
            buttonNext.isHidden = false
            buttonPrev.isHidden = false
        }
        
        buttonNext.reloadInputViews()
        buttonPrev.reloadInputViews()
    }
    
}
