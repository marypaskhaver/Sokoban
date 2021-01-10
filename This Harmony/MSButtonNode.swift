//
//  MSButtonNode.swift
//  Make School
//
//  Copyright (c) 2017 Make School. All rights reserved.
//

import SpriteKit

enum MSButtonNodeState {
    case MSButtonNodeStateActive, MSButtonNodeStateSelected, MSButtonNodeStateHidden
}

class MSButtonNode: SKSpriteNode {
    
    // Setup a dummy action closure
    var selectedHandler: () -> Void = { print("No button action set") }
    
    // Button state management
    var state: MSButtonNodeState = .MSButtonNodeStateActive {
        didSet {
            switch state {
            case .MSButtonNodeStateActive:
                // Enable touch
                self.isUserInteractionEnabled = true
                
                // Visible
                self.alpha = 1
                break
            case .MSButtonNodeStateSelected:
                // Semi transparent
                self.alpha = 0.7
                break
            case .MSButtonNodeStateHidden:
                // Disable touch
                self.isUserInteractionEnabled = false
                
                // Hide
                self.alpha = 0
                break
            }
        }
    }
    
    init(_ textureImage: SKTexture, _ size: CGSize, atPosition position: CGPoint) {
        super.init(texture: textureImage, color: UIColor.red, size: size)
        self.position = position
        self.zPosition = 1
        self.isUserInteractionEnabled = true
    }
    
    // Support for NSKeyedArchiver (loading objects from SK Scene Editor)
    required init?(coder aDecoder: NSCoder) {
        
        // Call parent initializer e.g. SKSpriteNode
        super.init(coder: aDecoder)
        
        self.zPosition = 1

        // Enable touch on button node
        self.isUserInteractionEnabled = true
    }
    
    // MARK: - Touch handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        state = .MSButtonNodeStateSelected
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        selectedHandler()
        state = .MSButtonNodeStateActive
    }
    
}
