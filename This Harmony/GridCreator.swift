//
//  GridCreator.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 1/2/21.
//

import Foundation
import SpriteKit

class GridCreator {
    var grid: [ [Tile] ] = [ [Tile] ]()
    var childrenToAddToView: [SKNode] = [SKNode]()
    var player: Player?
    
    func getGridOfScenesChildren(_ children: [SKNode]) -> [ [Tile] ] {
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
        
        return grid
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
                    
                    // Replace w/ Floor tile w/ non-nil player property
                    grid[row][col] = Floor(row: row, column: col)
                    (grid[row][col] as! Floor).player = player

                    childrenToAddToView.append(grid[row][col])
                    
                    self.player = player
                } else if grid[row][col].name == "crate" {
                    let crate: Crate = grid[row][col] as! Crate
                    
                    // Replace w/ Floor tile w/ non-nil crate property
                    grid[row][col] = Floor(row: row, column: col)
                    (grid[row][col] as! Floor).crate = crate
                    
                    childrenToAddToView.append(grid[row][col])
                }
                
            }
        }
    }
}
