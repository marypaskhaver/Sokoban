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
                        // clearTiles will include only the Floor tiles that do not have crates, whereas allFloor contains all, regardless of crates
                        let allFloorTilesInFrontOfLP: [Floor] = getAllFloorTilesInFrontOf(point: Point(row: row, col: col), inDirection: lp.direction)
                        let clearTiles: [Floor] = getClearFloorTiles(from: allFloorTilesInFrontOfLP)
                        
                        // Place lasers on all tiles, and hide them from all the tiles that are blocked / not clear
                        for tile in allFloorTilesInFrontOfLP {
                            let laserBeam: LaserBeam = LaserBeam(inDirection: lp.direction, atPoint: tile.position)
                            tile.laserBeam = laserBeam
                            childrenToAddToView[laserBeam] = laserBeam.position
                            
                            if !clearTiles.contains(tile) {
                                tile.laserBeam!.isHidden = true
                            }
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
                return clearTiles
            }
        }
        
        return clearTiles
    }
    
    // The way this is built, the player will never start the level on a storage area
    private func putFloorsUnderPlayerAndCrates() {
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
