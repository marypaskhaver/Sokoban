//
//  LaserSetterUpper.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 1/24/21.
//

import Foundation

class LaserSetterUpper {
    var grid: [[Tile]] = [ [Tile] ]()

    init(with grid: [[Tile]]) {
        self.grid = grid
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
}
