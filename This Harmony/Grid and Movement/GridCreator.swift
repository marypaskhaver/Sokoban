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
    var laserPointers: [LaserPointer] = [LaserPointer]()
    var childrenToAddToView: [Tile : CGPoint] = [Tile : CGPoint]()
    
    init(withChildren children: [SKNode]) {
        _ = getGridOfScenesChildren(children)
        laserPointers = getLaserPointerNodesFromScenesChildren(children)
        activateLaserBeams()
    }
    
    private func getGridOfScenesChildren(_ children: [SKNode]) -> [ [Tile] ] {
        var arrayOfNodes: [Tile] = []
        
        for child in children {
            // A player and crate will always be standing on a floor, so you can add them normally to the arrayOfNodes and just remember they're on Floor tiles;
            // replace them later
            child.position = CGPoint(x: child.getRoundedX(), y: child.getRoundedY())
            
            if child as? MSButtonNode == nil && child as? LaserPointer == nil {
                arrayOfNodes.append(child as! Tile)
            }
        }
        
        arrayOfNodes = arrayOfNodes.sorted(by: { $0.frame.midX < $1.frame.midX })
        arrayOfNodes = arrayOfNodes.sorted(by: { $0.frame.midY > $1.frame.midY })
                
        grid = arrayOfNodes.chunked(into: 8)

        for r in grid {
            var row = r
            row = row.sorted(by: { $0.frame.midX < $1.frame.midX })
        }
        
        // Replace player + crate nodes w/ Floor nodes that have crate and player properties
        putFloorsUnderPlayerAndCrates()

        return grid
    }
    
    private func getLaserPointerNodesFromScenesChildren(_ children: [SKNode]) -> [LaserPointer] {
        var laserPointers: [LaserPointer] = []

        for child in children {
            child.position = CGPoint(x: child.getRoundedX(), y: child.getRoundedY())
            
            if child as? LaserPointer != nil {
                (child as? LaserPointer)?.setDirection()
                laserPointers.append(child as! LaserPointer)
            }
        }
        
        return laserPointers
    }
    
    // Find where laser beams should go and add them to scene
    func activateLaserBeams() {
        // Find laser pointer nodes and their row/col in the grid
        for row in 0..<grid.count {
            for col in 0..<grid[row].count {
                for lp in laserPointers {
                    if grid[row][col].frame.midX == lp.frame.midX && grid[row][col].frame.midY == lp.frame.midY {
                        // For each laser pointer, check its rotation to find out which direction to place the beams (0 deg = pointing up, then -90 deg turns clockwise)
                        // Check how far a clear path extends in that direction on the grid-- that is, clear rows and cols (laser cannot go thru walls or crates)
                        let clearTiles: [Floor] = getLongestClearPathOfFloor(from: Point(row: row, col: col), inDirection: lp.direction)
                        
                        // For each of the clear tiles in the grid before the pointer, place a laser beam node rotated to the proper amount there
                        for tile in clearTiles {
                            let laserBeam: LaserBeam = LaserBeam(inDirection: lp.direction, atPoint: tile.position)
                            // For the Floors the laser beam crosses over, set its laserBeam property to that laserBeam node
                            tile.laserBeam = laserBeam
                            childrenToAddToView[laserBeam] = laserBeam.position
                        }
                    }
                }
            }
        }
        
    }
    
    func getLongestClearPathOfFloor(from point: Point, inDirection dir: Direction) -> [Floor] {
        var row: Int = point.row, col: Int = point.col
        var tilesInFront: [Floor] = [Floor]()
        
        switch dir {
        case .up:
            row -= 1 // Don't count wall which laser is attached to
            // Check if path free of crates and walls-- does this cover all scenarios?
            while (grid[row][col] as? Floor)?.crate == nil && grid[row][col].name != Constants.TileNames.wall.rawValue {
                tilesInFront.append(grid[row][col] as! Floor)
                row -= 1
            }

            print("collision up at \(row), \(col)")
        case .down:
            row += 1
            while (grid[row][col] as? Floor)?.crate == nil && grid[row][col].name != Constants.TileNames.wall.rawValue {
                tilesInFront.append(grid[row][col] as! Floor)
                row += 1
            }
            print("collision down at \(row), \(col)")
        case .left:
            col -= 1
            while (grid[row][col] as? Floor)?.crate == nil && grid[row][col].name != Constants.TileNames.wall.rawValue {
                tilesInFront.append(grid[row][col] as! Floor)
                col -= 1
            }
            
            print("collision left at \(row), \(col)")
        case .right:
            col += 1
            while (grid[row][col] as? Floor)?.crate == nil && grid[row][col].name != Constants.TileNames.wall.rawValue {
                tilesInFront.append(grid[row][col] as! Floor)
                col += 1
            }

            print("collision right at \(row), \(col)")
        }
        
        return tilesInFront
    }
    
    // The way this is built, the player will never start the level on a storage area
    func putFloorsUnderPlayerAndCrates() {
        for row in 0..<grid.count {
            for col in 0..<grid[row].count {
                
                if grid[row][col].name == Constants.TileNames.player.rawValue {
                    let playerNode: Player = grid[row][col] as! Player
                    
                    // Replace w/ Floor tile w/ non-nil player property
                    grid[row][col] = Floor()
                    (grid[row][col] as! Floor).player = playerNode
                    
                    let position: CGPoint = CGPoint(x: col * Constants.tileSize + 139, y: 900 - (row * Constants.tileSize))
                    (grid[row][col] as! Floor).position = position

                    childrenToAddToView[grid[row][col] as! Floor] = position
                } else if grid[row][col].name == Constants.TileNames.crate.rawValue {
                    let crate: Crate = grid[row][col] as! Crate
                    
                    // Replace w/ Floor tile w/ non-nil crate property
                    grid[row][col] = Floor()
                    (grid[row][col] as! Floor).crate = crate

                    let position: CGPoint = CGPoint(x: col * Constants.tileSize + 139, y: 900 - (row * Constants.tileSize))
                    (grid[row][col] as! Floor).position = position
                    
                    childrenToAddToView[grid[row][col] as! Floor] = position
                }
                
            }
        }
        
    }

}
