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
    var laserPointers: [LaserPointer]
    
    init(with2DArrayOfTiles gridTiles: [ [Tile] ], laserPointers: [LaserPointer]) {
        self.grid = gridTiles
        self.laserPointers = laserPointers
        activateLaserBeams()
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
    
    func activateLaserBeams() {
        // Find laser pointer nodes and their row/col in the grid
        for row in 0..<grid.count {
            for col in 0..<grid[row].count {
                for lp in laserPointers {
                    if grid[row][col].frame.midX == lp.frame.midX && grid[row][col].frame.midY == lp.frame.midY {
                        // For each laser pointer, check its rotation to find out which direction to place the beams (0 deg = pointing up, then -90 deg turns clockwise)
                        let clearTiles: [Floor] = getLongestClearPathOfFloor(from: Point(row: row, col: col), inDirection: lp.direction)
                    }
                }
            }
        }
        // Find laser pointer nodes and their row/col in the grid
        // For each laser pointer, check its rotation to find out which direction to place the beams (0 deg = pointing up, other dirs are clockwise in sets of 90)
        // Check how far a clear path extends in that direction on the grid-- that is, clear rows and cols (laser cannot go thru walls or crates)
        // For each of the clear rows/cols in the grid, place a laser beam node rotated to the proper amount there
        // For the Floors the laser beam crosses over, set its laserBeam property to that laserBeam node
    }
    
    func getLongestClearPathOfFloor(from point: Point, inDirection dir: Direction) -> [Floor] {
        var row: Int = point.row, col: Int = point.col
        
        switch dir {
        case .up:
            row -= 1
            
            // Check if path free of crates and walls-- does this cover all scenarios?
            while (grid[row][col] as? Floor)?.crate == nil && grid[row][col].name != Constants.TileNames.wall.rawValue {
                print("uppity")
                row -= 1
            }
            
            print("collision at \(row), \(col)")
            break
        case .down:
            print("a")
            break
        case .left:
            print("b")
            break
        case .right:
            print("c")
            break
        }
        
        return []
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
