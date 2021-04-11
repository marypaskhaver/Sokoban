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
    var lowestSteps: Int = 0
    var currentSteps: Int = 0
    var laserPointers: [LaserPointer] = [LaserPointer]()
    var cdm: CoreDataManager!

    init(with2DArrayOfTiles gridTiles: [ [Tile] ], laserPointers lp: [LaserPointer], withCoreDataManager cdm: CoreDataManager) {
        self.grid = gridTiles
        self.laserPointers = lp
        self.cdm = cdm
        print("INITIALIZING GRID")
        loadStepData()
    }
    
    func movePlayer(inDirection dir: Direction) {
        let mover: PlayerMover = PlayerMover(with2DArrayOfTiles: grid)
        mover.movePlayer(inDirection: dir)
        grid = mover.grid
        
        if mover.didPlayerMove {
            currentSteps += 1
            // Later, save steps and add onto the saved # each time. Reset steps upon level reset.
        }
        
        if mover.didMoveCrate {
            hideBlockedLaserBeams()
        }
    }
    
    func loadStepData() {
        lowestSteps = Int(cdm.fetchCompletedLevelWithLowestSteps().lowestSteps)
        print(cdm.fetchCompletedLevelWithLowestSteps())
        print("Loading step data ~ lowest steps: \(lowestSteps)")
    }
    
    func updateStepDataIfNeeded() {
        // If currentSteps are the lowest ever, set them as the level's lowestSteps in CoreData
        if currentSteps < lowestSteps || lowestSteps == 0 {
            print("current steps are lower than lowestSteps-- update data")
            _ = cdm.insertCompletedLevel(levelNumber: Int32(GameScene.level), lowestSteps: Int32(currentSteps))
            lowestSteps = currentSteps
            cdm.save()
        }

        currentSteps = 0
    }
    
    func hideBlockedLaserBeams() {
        for lp in laserPointers {
            // This reloads all the laser pointers-- make it reload just the one(s) w/ a blocked beam
            let topLeftNode: Tile = self.grid[0][0]
            
            let lpRowAndCol: GridPoint = GridPoint(row: (-Int(lp.position.y) + Int(topLeftNode.getRoundedY())) / Constants.tileSize, col: (Int(lp.position.x) - Int(topLeftNode.getRoundedX())) / Constants.tileSize)            
            let lsu: LaserSetterUpper = LaserSetterUpper(with: grid)
            let allFloorTilesInFrontOfLP: [Floor] = lsu.getAllFloorTilesInFrontOf(point: GridPoint(row: lpRowAndCol.row, col: lpRowAndCol.col), inDirection: lp.direction)
            let clearTiles: [Floor] = lsu.getClearFloorTiles(from: allFloorTilesInFrontOfLP)
            
            if clearTiles.count < lp.laserBeams.filter( { !$0.isHidden } ).count {
                for tile in allFloorTilesInFrontOfLP {
                    if !clearTiles.contains(tile) {
                        // Can't ever have two laser pointers of the same direction on one spot
                        // Does the abs make a risk for deleting the wrong beam? Ie, if two beams (L + R or U + D) are opposite ea. o.
                        // Could be fixed by converting all -180 to 180 and -90 to 270
                        tile.laserBeams.first(where: { abs($0.zRotation) == abs(lp.zRotation) })?.isHidden = true
                        if let crate = tile.crate {
                            if tile.laserBeams.filter( { $0.isHidden } ).count == tile.laserBeams.count {
                                print("Crate no longer on active beam")
                                crate.isOnActiveLaserBeam = false
                            }
                        }
                    }
                }
            }
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
