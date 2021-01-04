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
    var player: Player? // Could remove this and get playerInfo thru method that finds Player obj in one of the Floor tiles?
    var cratePushes: Int = 0
    
    init(with2DArrayOfTiles gridTiles: [ [Tile] ], withPlayerNode player: Player) {
        self.grid = gridTiles
        self.player = player
    }
    
    func movePlayer(inDirection dir: Direction) {
        let mover: PlayerMover = PlayerMover(with2DArrayOfTiles: grid, withPlayerNode: player!)
        mover.movePlayer(inDirection: dir)
        grid = mover.grid
        player = mover.player
        
        if mover.didMoveCrate {
            cratePushes += 1
            // Later, save cratePushes and add onto the saved # each time. Reset cratePushes upon level reset.
        }
        
        // Check if level is complete
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
