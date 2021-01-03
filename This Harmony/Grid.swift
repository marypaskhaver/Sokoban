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
    
    init(with2DArrayOfTiles gridTiles: [ [Tile] ], withPlayerNode player: Player) {
        grid = gridTiles
        self.player = player
    }
    
    func canPlayerMove(inDirection dir: Direction) -> Bool {
        var tilesInFront: (Tile, Tile)!
        
        switch dir {
        case .up:
            if player!.row == 1 { return false }
            tilesInFront = getAdjacentTiles(inDirection: .up)
        case .down:
            if player!.row == 6 { return false }
            tilesInFront = getAdjacentTiles(inDirection: .down)
        case .left:
            if player!.column == 1 { return false }
            tilesInFront = getAdjacentTiles(inDirection: .left)
        case .right:
            if player!.column == 10 { return false }
            tilesInFront = getAdjacentTiles(inDirection: .right)
        default:
            print("Unknown direction")
        }
        
        return isPlayersPathClear(twoTilesInFrontOfPlayer: tilesInFront)

    }
    
    func getAdjacentTiles(inDirection dir: Direction) -> (Tile, Tile) {
        var oneTileFromPlayer: Tile!
        var twoTilesFromPlayer: Tile!
        
        switch dir {
        case .up:
            oneTileFromPlayer = grid[player!.row - 1][player!.column]
            twoTilesFromPlayer = grid[player!.row - 2][player!.column]
        case .down:
            oneTileFromPlayer = grid[player!.row + 1][player!.column]
            twoTilesFromPlayer = grid[player!.row + 2][player!.column]
        case .left:
            oneTileFromPlayer = grid[player!.row][player!.column - 1]
            twoTilesFromPlayer = grid[player!.row][player!.column - 2]
        case .right:
            oneTileFromPlayer = grid[player!.row][player!.column + 1]
            twoTilesFromPlayer = grid[player!.row][player!.column + 2]
        default:
            print("Unknown direction")
        }
        
        return (oneTileFromPlayer, twoTilesFromPlayer)
    }
    
    func isPlayersPathClear(twoTilesInFrontOfPlayer: (Tile, Tile)) -> Bool {
        let oneTileFromPlayer: Tile = twoTilesInFrontOfPlayer.0
        let twoTilesFromPlayer: Tile = twoTilesInFrontOfPlayer.1
        
        if  oneTileFromPlayer.name == Constants.TileNames.wall.rawValue ||
            (isFloorThatContainsCrate(oneTileFromPlayer) && twoTilesFromPlayer.name == Constants.TileNames.wall.rawValue) ||
            (isFloorThatContainsCrate(oneTileFromPlayer) && isFloorThatContainsCrate(twoTilesFromPlayer)) {
            return false
        }
        
        return true
    }
    
    func isFloorThatContainsCrate(_ tile: Tile) -> Bool {
        if let floor = tile as? Floor {
            return floor.crate != nil
        }
        
        return false
    }
    
    struct Point {
        var row: Int = 0
        var col: Int = 0
    }
    
    func getRowAndColumnOfFloor(floorNodeInGrid floorNode: Floor) -> Point {
        for row in 0..<grid.count {
            for col in 0..<grid[row].count {
                if grid[row][col] == floorNode {
                    return Point(row: row, col: col)
                }
            }
        }
        
        return Point(row: -1, col: -1)
    }
    
    // Update grid properties: Set current Floor item that the crate is on to not have a crate property; move the crate property to the
    // square immediately below the current Floor.
    func moveCrateIfNeeded(onTile tile: Tile, inDirection dir: Direction) {
        if isFloorThatContainsCrate(tile) {
            let floorThatHoldsCrateInFrontofPlayer: Floor = tile as! Floor
            let positionOfFloorThatHoldsCrateInFrontOfPlayer: Point = getRowAndColumnOfFloor(floorNodeInGrid: floorThatHoldsCrateInFrontofPlayer)
            
            switch dir {
            case .up:
                (grid[positionOfFloorThatHoldsCrateInFrontOfPlayer.row - 1][positionOfFloorThatHoldsCrateInFrontOfPlayer.col] as! Floor).crate = floorThatHoldsCrateInFrontofPlayer.crate as! Crate
                (floorThatHoldsCrateInFrontofPlayer.crate as! Crate).moveUp(byNumTiles: 1)
                break
            case .down:
                (grid[positionOfFloorThatHoldsCrateInFrontOfPlayer.row + 1][positionOfFloorThatHoldsCrateInFrontOfPlayer.col] as! Floor).crate = floorThatHoldsCrateInFrontofPlayer.crate as! Crate
                (floorThatHoldsCrateInFrontofPlayer.crate as! Crate).moveDown(byNumTiles: 1)
                break
            case .left:
                (grid[positionOfFloorThatHoldsCrateInFrontOfPlayer.row][positionOfFloorThatHoldsCrateInFrontOfPlayer.col - 1] as! Floor).crate = floorThatHoldsCrateInFrontofPlayer.crate as! Crate
                (floorThatHoldsCrateInFrontofPlayer.crate as! Crate).moveLeft(byNumTiles: 1)
                break
            case .right:
                (grid[positionOfFloorThatHoldsCrateInFrontOfPlayer.row][positionOfFloorThatHoldsCrateInFrontOfPlayer.col + 1] as! Floor).crate = floorThatHoldsCrateInFrontofPlayer.crate as! Crate
                (floorThatHoldsCrateInFrontofPlayer.crate as! Crate).moveRight(byNumTiles: 1)
                break
            default:
                print("Unknown direction")
            }
            
            floorThatHoldsCrateInFrontofPlayer.crate = nil
        }
    }
    
    // The row and col properties of Floors (and Crates) are not changed at all throughout the game-- only the Floors crate and player properties are
    func movePlayer(inDirection dir: Direction) {
        switch dir {
        case .up:
            if canPlayerMove(inDirection: .up) {
                let oneTileFromPlayer: Tile = getAdjacentTiles(inDirection: .up).0

                moveCrateIfNeeded(onTile: oneTileFromPlayer, inDirection: .up)
                
                ((grid[player!.row][player!.column]) as! Floor).player = nil
                player!.row -= 1
                (oneTileFromPlayer as! Floor).player = player
                player!.moveUp(byNumTiles: 1)
            }
        case .down:
            if canPlayerMove(inDirection: .down) {
                let oneTileFromPlayer: Tile = getAdjacentTiles(inDirection: .down).0
                
                moveCrateIfNeeded(onTile: oneTileFromPlayer, inDirection: .down)
                
                ((grid[player!.row][player!.column]) as! Floor).player = nil // Set current Floor's player property to nil bc player is moving off of it
                player!.row += 1 // Inc player's row
                (oneTileFromPlayer as! Floor).player = player // Set tile in front of player (floor) to have player property
                player!.moveDown(byNumTiles: 1) // Animate player
            }
        case .left:
            if canPlayerMove(inDirection: .left) {
                let oneTileFromPlayer: Tile = getAdjacentTiles(inDirection: .left).0
                
                moveCrateIfNeeded(onTile: oneTileFromPlayer, inDirection: .left)
                
                ((grid[player!.row][player!.column]) as! Floor).player = nil
                player!.column -= 1
                (oneTileFromPlayer as! Floor).player = player
                player!.moveLeft(byNumTiles: 1)
            }
        case .right:
            if canPlayerMove(inDirection: .right) {
                let oneTileFromPlayer: Tile = getAdjacentTiles(inDirection: .right).0
                
                moveCrateIfNeeded(onTile: oneTileFromPlayer, inDirection: .right)
                
                ((grid[player!.row][player!.column]) as! Floor).player = nil
                player!.column += 1
                (oneTileFromPlayer as! Floor).player = player
                player!.moveRight(byNumTiles: 1)
            }
        default:
            print("Unknown direction")
        }
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
