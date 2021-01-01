//
//  Grid.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 12/31/20.
//

import Foundation
import SpriteKit

class Grid {
    
    var grid: [[SKSpriteNode]] = [ [SKSpriteNode] ]()
    
    init(withChildren children: [SKNode]) {
        var arrayOfNodes: [SKSpriteNode] = []
        
        for child in children {
            // A player and crate will always be standing on a floor, so you can add them normally to the arrayOfNodes and just remember they're on Floor tiles;
            // Maybe create Floor tiles underneath them.
            child.position = CGPoint(x: child.getRoundedX(), y: child.getRoundedY())
            arrayOfNodes.append(child as! SKSpriteNode)
        }
        
        arrayOfNodes = arrayOfNodes.sorted(by: { $0.frame.midX < $1.frame.midX })
        arrayOfNodes = arrayOfNodes.sorted(by: { $0.frame.midY > $1.frame.midY })
                
        grid = arrayOfNodes.chunked(into: 12)
        
        for r in grid {
            var row = r
            row = row.sorted(by: { $0.frame.midX < $1.frame.midX })
        }
    }
    
    func printGrid() {
        for row in grid {
            for node in row {
                print(node.name, node.frame.midX, node.frame.midY)
            }
            print()
        }
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

extension SKNode {
    func getRoundedX() -> CGFloat {
        return self.position.x.rounded()
    }
    
    func getRoundedY() -> CGFloat {
        return self.position.y.rounded()
    }
}
