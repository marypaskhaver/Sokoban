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
    var steps: Int = 0
    
    init(with2DArrayOfTiles gridTiles: [ [Tile] ]) {
        self.grid = gridTiles
    }
    
    func movePlayer(inDirection dir: Direction) {
        let mover: PlayerMover = PlayerMover(with2DArrayOfTiles: grid)
        mover.movePlayer(inDirection: dir)
        grid = mover.grid
        
        if mover.didPlayerMove {
            steps += 1
            // Later, save steps and add onto the saved # each time. Reset steps upon level reset.
        }
        
        if mover.didMoveCrate {            
            // Check if level is complete
            print(isLevelComplete())
        }
    }
    
    func isLevelComplete() -> Bool {
        // Go through the grid and find every Floor node w/ the name "storage"
        // If all the storage nodes have a crate property (that is, the crate property is not nil), return true
        var storageTiles: [Storage] = [Storage]()
        
        for row in grid {
            for node in row {
                if node.name == Constants.TileNames.storage.rawValue {
                    storageTiles.append(node as! Storage)
                }
            }
        }
        
        return storageTiles.allSatisfy( { $0.crate != nil } )
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