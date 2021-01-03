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
    var childrenToAddToView: [Floor : CGPoint] = [Floor : CGPoint]()

    var player: Player?
    
    func getGridOfScenesChildren(_ children: [SKNode]) -> [ [Tile] ] {
        var arrayOfNodes: [Tile] = []
        
        for child in children {
            // A player and crate will always be standing on a floor, so you can add them normally to the arrayOfNodes and just remember they're on Floor tiles;
            // replace them later
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
        
        // Replace player + crate nodes w/ Floor nodes that have crate and player properties
        putFloorsUnderPlayerAndCrates()
        assignPlayerRowAndColumn()

        return grid
    }
    
    func assignPlayerRowAndColumn() {
        for row in 0..<grid.count {
            for col in 0..<grid[row].count {
                let tile: Tile = grid[row][col] // Every element is at least of type Tile
                
                if tile.name == Constants.TileNames.floor.rawValue {
                    let playerNode: Player? = (tile as! Floor).player as? Player
                    
                    if playerNode != nil {
                        player!.row = row
                        player!.column = col
                    }
                }
            }
        }
    }
    
    // The way this is built, the player will never start the level on a storage area
    func putFloorsUnderPlayerAndCrates() {
        for row in 0..<grid.count {
            for col in 0..<grid[row].count {
                
                if grid[row][col].name == Constants.TileNames.player.rawValue {
                    let player: Player = grid[row][col] as! Player
                    
                    // Replace w/ Floor tile w/ non-nil player property
                    grid[row][col] = Floor()
                    (grid[row][col] as! Floor).player = player

                    childrenToAddToView[grid[row][col] as! Floor] = CGPoint(x: col * Constants.tileSize + 64, y: 656 - (row * Constants.tileSize))
                    
                    self.player = player
                } else if grid[row][col].name == Constants.TileNames.crate.rawValue {
                    let crate: Crate = grid[row][col] as! Crate
                    
                    // Replace w/ Floor tile w/ non-nil crate property
                    grid[row][col] = Floor()
                    (grid[row][col] as! Floor).crate = crate
                    
                    childrenToAddToView[grid[row][col] as! Floor] = CGPoint(x: col * Constants.tileSize + 64, y: 656 - (row * Constants.tileSize))
                }
                
            }
        }
    }
}
