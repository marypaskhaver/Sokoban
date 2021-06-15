//
//  StepLabel.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 4/9/21.
//

import SpriteKit

class StepLabel: SKLabelNode {
            
    init(withText text: String, at position: CGPoint) {
        super.init()
        
        self.text = text
        self.position = CGPoint(x: position.x, y: position.y)
        self.fontSize = 40
        self.horizontalAlignmentMode = .center
        self.fontColor = UIColor.white
        self.fontName = "PlayMeGames"
        self.zPosition = 3
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
