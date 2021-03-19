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
    var gvc: GameViewController!
    
    override func didMove(to view: SKView) {
        // Set UI connections
        buttonPlay = self.childNode(withName: "buttonPlay") as! MSButtonNode
        
        buttonPlay.selectedHandler = {
            self.gvc.presentLevelMenu()
        }
        
    }
    
}
