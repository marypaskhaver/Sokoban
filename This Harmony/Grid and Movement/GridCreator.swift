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
        
//        printGrid()
        
        laserPointers = getLaserPointerNodesFromScenesChildren(children)

        activateLaserBeams()
    }
    
//    func printGrid() {
//        for row in grid {
//            for node in row {
//
//                if node as? Floor != nil {
//                    if node as? Storage != nil {
//                        print("storage \(node.position)")
//                    } else if (node as! Floor).player != nil {
//                        print("player \(node.position)")
//                    } else if (node as! Floor).crate != nil {
//                        print("crate \(node.position)")
//                    } else {
//                        print("floor \(node.position)")
//                    }
//                } else {
//                    print(node.name ?? "no name" + " ")
//                    print("wall above has position \(node.position) ")
//                }
//            }
//            print()
//        }
//        print("------------------")
//    }
    
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
                
//        Assumes grid will be rect. Will find max number of nodes w/ same y-val (# of columns) and chunk grid by that.
        let firstYVal = arrayOfNodes[0].frame.midY
        
        let maxNumOfNodesWithFirstYVal: Int = arrayOfNodes.filter { (tile: Tile) -> Bool in
            tile.frame.midY == firstYVal
        }.count
                
        grid = arrayOfNodes.chunked(into: maxNumOfNodesWithFirstYVal)

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
                (child as! LaserPointer).setDirection()
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
                    if grid[row][col].frame.midX == lp.frame.midX && grid[row][col].frame.midY == lp.frame.midY { // Locate pointer
                        // clearTiles will include only the Floor tiles that do not have crates, whereas allFloor contains all, regardless of crates
                        let lsu: LaserSetterUpper = LaserSetterUpper(with: grid)
                        let allFloorTilesInFrontOfLP: [Floor] = lsu.getAllFloorTilesInFrontOf(point: GridPoint(row: row, col: col), inDirection: lp.direction)
                        let clearTiles: [Floor] = lsu.getClearFloorTiles(from: allFloorTilesInFrontOfLP)
                        
                        // Place lasers on all tiles, and hide them from all the tiles that are blocked / not clear
                        for tile in allFloorTilesInFrontOfLP {
                            let laserBeam: LaserBeam = LaserBeam(inDirection: lp.direction, atPoint: tile.position)
                            tile.laserBeams.append(laserBeam)
                            lp.laserBeams.append(laserBeam)
                            childrenToAddToView[laserBeam] = laserBeam.position
                        }
                        
                        for tile in clearTiles {
                            for lb in tile.laserBeams {
                                lb.isHidden = false
                            }
                            
                            if tile.crate != nil { tile.crate?.isOnActiveLaserBeam = true }
                        }
                    }
                }
            }
        }
    }
    
    // The way this is built, the player will never start the level on a storage area
    private func putFloorsUnderPlayerAndCrates() {
        for row in 0..<grid.count {
            for col in 0..<grid[row].count {
                
                if grid[row][col].name == Constants.TileNames.player.rawValue {
                    let playerNode: Player = grid[row][col] as! Player
                    
                    // Replace w/ Floor tile w/ non-nil player property
                    grid[row][col] = Floor(withPlayerFloorImage: Tile.constants.getLevelTheme().playerFloorImage)

                    (grid[row][col] as! Floor).player = playerNode
                    
                    let firstNodePosition: CGPoint = grid[0][0].position // Assumes grid is a rectangle

                    let position: CGPoint = CGPoint(x: col * Constants().tileSize + Int(firstNodePosition.x), y: Int(firstNodePosition.y) - (row * Constants().tileSize))
                    (grid[row][col] as! Floor).position = position

                    childrenToAddToView[grid[row][col] as! Floor] = position
                } else if grid[row][col].name == Constants.TileNames.crate.rawValue {
                    let crate: Crate = grid[row][col] as! Crate
                    
                    // Replace w/ Floor tile w/ non-nil crate property
                    grid[row][col] = Floor()

                    (grid[row][col] as! Floor).crate = crate

                    let firstNodePosition: CGPoint = grid[0][0].position // Assumes grid is a rectangle

                    let position: CGPoint = CGPoint(x: col * Constants().tileSize + Int(firstNodePosition.x), y: Int(firstNodePosition.y) - (row * Constants().tileSize))
                    (grid[row][col] as! Floor).position = position
                    
                    childrenToAddToView[grid[row][col] as! Floor] = position
                }
                
            }
        }
        
    }

}
