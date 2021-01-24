//
//  SKNode+RoundedPosition.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 1/24/21.
//

extension SKNode {
    func getRoundedX() -> CGFloat {
        return self.position.x.rounded()
    }
    
    func getRoundedY() -> CGFloat {
        return self.position.y.rounded()
    }
}
