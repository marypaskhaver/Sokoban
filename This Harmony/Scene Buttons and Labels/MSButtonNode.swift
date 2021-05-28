//
//  MSButtonNode.swift
//  Make School
//
//  Copyright (c) 2017 Make School. All rights reserved.
//

import SpriteKit

enum MSButtonNodeState {
    case active, selected, disabled
}

class MSButtonNode: SKSpriteNode {
    
    // Setup a dummy action closure
    var selectedHandler: () -> Void = { print("No button action set") }
    
    // Button state management
    var state: MSButtonNodeState = .active {
        didSet {
            switch state {
            case .active:
                // Enable touch
                self.isUserInteractionEnabled = true
                
                // Visible
                self.alpha = 1
                break
            case .selected:
                // Semi transparent
                self.alpha = 0.7
                break
            case .disabled:
                // Disable touch
                self.alpha = 0.5
                self.isUserInteractionEnabled = false
                break
            }
        }
    }
    
    init(withName name: String = "", _ textureImage: SKTexture, _ size: CGSize, atPosition position: CGPoint) {
        super.init(texture: textureImage, color: UIColor.red, size: size)
        self.position = position
        self.zPosition = 1
        self.isUserInteractionEnabled = true
        self.name = name
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
        state = .selected
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        selectedHandler()
        state = .active
    }
    
}
