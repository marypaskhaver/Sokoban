//
//  GridInformation.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 4/13/21.
//

import Foundation

class GridInformation {
    
    let grid: [[Tile]]
    
    init(withGrid grid: [[Tile]]) {
        self.grid = grid
    }
    
    func isFloorThatContainsCrate(_ tile: Tile) -> Bool {
        if let floor = tile as? Floor {
            return floor.crate != nil
        }
        
        return false
    }
    
    func numberOfCratesOnStorageTiles() -> Int {
        var sumCrates: Int = 0
        
        for row in 0..<grid.count {
            for col in 0..<grid[row].count {
                if let storage = grid[row][col] as? Storage {
                    if storage.crate != nil {
                        sumCrates += 1
                    }
                }
            }
        }
        
        return sumCrates
    }
    
    func getRowAndColumnOfFloor(floorNodeInGrid floorNode: Floor) -> GridPoint {
        for row in 0..<grid.count {
            for col in 0..<grid[row].count {
                if grid[row][col] == floorNode {
                    return GridPoint(row: row, col: col)
                }
            }
        }
        
        return GridPoint(row: -1, col: -1)
    }
    
    func getPlayerRowAndCol() -> GridPoint {
        for row in 0..<grid.count {
            for col in 0..<grid[row].count {
                if grid[row][col] as? Floor != nil {
                    let node: Floor = grid[row][col] as! Floor

                    if node.player != nil {
                        return GridPoint(row: row, col: col)
                    }
                }
            }
        }
        
        return GridPoint(row: -1, col: -1)
    }
    
}
