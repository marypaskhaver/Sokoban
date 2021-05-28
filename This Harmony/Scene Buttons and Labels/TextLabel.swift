//
//  TextLabel.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 1/10/21.
//

import SpriteKit

class TextLabel: SKLabelNode {
    
    init(_ text: String, at position: CGPoint) {
        super.init()
        self.text = text
        self.fontName = "PlayMeGames"
        self.fontSize = 40
        self.position = position
        self.zPosition = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
