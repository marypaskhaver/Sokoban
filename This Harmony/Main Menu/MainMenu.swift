//
//  MainMenu.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 1/6/21.
//

import Foundation
import SpriteKit

class MainMenu: SKScene {

    var buttonPlay: MSButtonNode!
    var buttonSkins: MSButtonNode!
    var logo: SKSpriteNode!

    var gvc: GameViewController!
    
    override func didMove(to view: SKView) {
        // Set UI connections
        buttonPlay = self.childNode(withName: "buttonPlay") as! MSButtonNode
        
        buttonPlay.selectedHandler = {
            self.gvc.presentLevelMenu()
        }
        
        buttonSkins = self.childNode(withName: "buttonSkins") as! MSButtonNode
        
        buttonSkins.selectedHandler = {
            self.gvc.presentSkinsMenu()
        }
        
        // Animate logo
        logo = self.childNode(withName: "logo") as! SKSpriteNode
        
        let moveUp: SKAction = SKAction.move(by: CGVector(dx: 0, dy: 10) , duration: 1)
        let moveDown: SKAction = SKAction.move(by: CGVector(dx: 0, dy: -10) , duration: 1)
        
        logo.run(SKAction.repeatForever(SKAction.sequence([moveUp, moveDown])))
    }
    
}
