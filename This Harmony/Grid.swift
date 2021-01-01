//
//  Grid.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 12/31/20.
//

import Foundation
import SpriteKit

class Grid {
    
    var grid: [[Tile]] = [ [Tile] ]()
    
    init(withChildren children: [SKNode]) {
        var arrayOfNodes: [Tile] = []
        
        for child in children {
            // A player and crate will always be standing on a floor, so you can add them normally to the arrayOfNodes and just remember they're on Floor tiles;
            // Maybe create Floor tiles underneath them.
            child.position = CGPoint(x: child.getRoundedX(), y: child.getRoundedY())
            arrayOfNodes.append(child as! Tile)
        }
        
        arrayOfNodes = arrayOfNodes.sorted(by: { $0.frame.midX < $1.frame.midX })
        arrayOfNodes = arrayOfNodes.sorted(by: { $0.frame.midY > $1.frame.midY })
                
        grid = arrayOfNodes.chunked(into: 12)
        
        for r in grid {
            var row = r
            row = row.sorted(by: { $0.frame.midX < $1.frame.midX })
        }
        
        assignNodesRowsAndColumns()
        putFloorsUnderPlayerAndCrates()
    }
    
    func assignNodesRowsAndColumns() {
        for row in 0..<grid.count {
            for col in 0..<grid[row].count {
                let tile: Tile = grid[row][col] // Every element is at least of type Tile
                tile.row = row
                tile.column = col
            }
        }
    }
    
    func putFloorsUnderPlayerAndCrates() {
        for row in 0..<grid.count {
            for col in 0..<grid[row].count {
                if grid[row][col].name == "player" {
                    let player: Player = grid[row][col] as! Player
                    
                    // Replace w/ Floor tile
                    grid[row][col] = Floor(texture: SKTexture(imageNamed: "floor"), name: "floor", row: row, column: col)
                    (grid[row][col] as! Floor).player = player
                } else if grid[row][col].name == "crate" {
                    let crate: Crate = grid[row][col] as! Crate
                    
                    // Replace w/ Crate tile
                    grid[row][col] = Floor(texture: SKTexture(imageNamed: "floor"), name: "floor", row: row, column: col)
                    (grid[row][col] as! Floor).crate = crate

                }
                
            }
        }
    }
    
    func printGrid() {
        for row in grid {
            for node in row {
                print(node.name, node.row, node.column)
                
                if node.name == "floor" {
                    if (node as! Floor).player != nil {
                        print("has player")
                    } else if (node as! Floor).crate != nil {
                        print("has crate")
                    }
                }
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
