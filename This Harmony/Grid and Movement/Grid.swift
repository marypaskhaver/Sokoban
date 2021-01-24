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
    var laserPointers: [LaserPointer] = [LaserPointer]()

    init(with2DArrayOfTiles gridTiles: [ [Tile] ], laserPointers lp: [LaserPointer]) {
        self.grid = gridTiles
        self.laserPointers = lp
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
            hideBlockedLaserBeams()
            
            // Check if level is complete
            print(isLevelComplete())
        }
    }
    
    func hideBlockedLaserBeams() {
        for lp in laserPointers {
            // This reloads all the laser pointers-- make it reload just the one(s) w/ a blocked beam
            let lpRowAndCol: Point = Point(row: (-Int(lp.position.y) + 900) / Constants.tileSize, col: (Int(lp.position.x) - 139) / Constants.tileSize)
            let allFloorTilesInFrontOfLP: [Floor] = getAllFloorTilesInFrontOf(point: Point(row: lpRowAndCol.row, col: lpRowAndCol.col), inDirection: lp.direction)
            let clearTiles: [Floor] = getClearFloorTiles(from: allFloorTilesInFrontOfLP)
                
            if clearTiles.count < lp.laserBeams.filter( { !$0.isHidden } ).count {
                for tile in allFloorTilesInFrontOfLP {
                    if !clearTiles.contains(tile) {
                        // Can't ever have two laser pointers of the same direction on one spot
                        // Does the abs make a risk for deleting the wrong beam? Ie, if two beams (L + R or U + D) are opposite ea. o.
                        // Could be fixed by converting all -180 to 180 and -90 to 270
                        tile.laserBeams.first(where: { abs($0.zRotation) == abs(lp.zRotation) })?.isHidden = true
                        if let crate = tile.crate {
                            crate.isOnActiveLaserBeam = false
                        }
                    }
                }
            }
        }
    }
    
    func getAllFloorTilesInFrontOf(point pt: Point, inDirection dir: Direction) -> [Floor] {
        var row: Int = pt.row, col: Int = pt.col
        var tilesInFront: [Floor] = [Floor]()
        
        switch dir {
        case .up:
            row -= 1 // Don't count wall which laser is attached to
            // Go until you hit a wall
            while grid[row][col].name != Constants.TileNames.wall.rawValue {
                tilesInFront.append(grid[row][col] as! Floor)
                row -= 1
            }
        case .down:
            row += 1
            while grid[row][col].name != Constants.TileNames.wall.rawValue {
                tilesInFront.append(grid[row][col] as! Floor)
                row += 1
            }
        case .left:
            col -= 1
            while grid[row][col].name != Constants.TileNames.wall.rawValue {
                tilesInFront.append(grid[row][col] as! Floor)
                col -= 1
            }
        case .right:
            col += 1
            while grid[row][col].name != Constants.TileNames.wall.rawValue {
                tilesInFront.append(grid[row][col] as! Floor)
                col += 1
            }
        }
        
        return tilesInFront
    }
    
    // No crates
    func getClearFloorTiles(from floorTiles: [Floor]) -> [Floor] {
        var clearTiles: [Floor] = [Floor]()
        
        for tile in floorTiles {
            if tile.crate == nil {
                clearTiles.append(tile)
            } else {
                // When you encounter a crate, cut off immediately, bc there should be no lasers after it
                clearTiles.append(tile)
                return clearTiles
            }
        }
        
        return clearTiles
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
