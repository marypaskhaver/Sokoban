//
//  PlayerMover.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 1/2/21.
//

import Foundation
import SpriteKit

class PlayerMover {
    var grid: [[Tile]] = [ [Tile] ]()
    var didMoveCrate: Bool = false
    var didPlayerMove: Bool = false
    
    init(with2DArrayOfTiles gridTiles: [ [Tile] ]) {
        self.grid = gridTiles
    }
    
    func getPlayerRowAndCol() -> Point {
        for row in 0..<grid.count {
            for col in 0..<grid[row].count {
                if grid[row][col] as? Floor != nil {
                    let node: Floor = grid[row][col] as! Floor

                    if node.player != nil {
                        return Point(row: row, col: col)
                    }
                }
            }
        }
        
        return Point(row: -1, col: -1)
    }
    
    func canPlayerMove(inDirection dir: Direction) -> Bool {
        var tilesInFront: (Tile, Tile)!
        let playerLocation: Point = getPlayerRowAndCol()
        var notMovingCratesOnActiveLasers: Bool = true
        
        switch dir {
        case .up:
            if playerLocation.row == 1 { return false }
            tilesInFront = getAdjacentTiles(inDirection: .up)
            
            if isFloorThatContainsCrate(tilesInFront.0) {
                if let crate = (tilesInFront.0 as! Floor).crate {
                    if crate.isOnActiveLaserBeam {
                        notMovingCratesOnActiveLasers = (tilesInFront.0 as! Floor).laserBeams.first(where: { $0.isHidden && $0.direction == .down }) != nil ? true : false
                    }
                }
            }
            
        case .down:
            if playerLocation.row == 8 { return false }
            tilesInFront = getAdjacentTiles(inDirection: .down)
            
            if isFloorThatContainsCrate(tilesInFront.0) {
                if let crate = (tilesInFront.0 as! Floor).crate {
                    if crate.isOnActiveLaserBeam {
                        notMovingCratesOnActiveLasers = (tilesInFront.0 as! Floor).laserBeams.first(where: { $0.isHidden && $0.direction == .up }) != nil ? true : false
                    }
                }
            }
            
        case .left:
            if playerLocation.col == 1 { return false }
            tilesInFront = getAdjacentTiles(inDirection: .left)
            
            if isFloorThatContainsCrate(tilesInFront.0) {
                if let crate = (tilesInFront.0 as! Floor).crate {
                    if crate.isOnActiveLaserBeam {
                        notMovingCratesOnActiveLasers = (tilesInFront.0 as! Floor).laserBeams.first(where: { $0.isHidden && $0.direction == .right }) != nil ? true : false
                    }
                }
            }

        case .right:
            if playerLocation.col == 6 { return false }
            tilesInFront = getAdjacentTiles(inDirection: .right)
            
            if isFloorThatContainsCrate(tilesInFront.0) {
                if let crate = (tilesInFront.0 as! Floor).crate {
                    if crate.isOnActiveLaserBeam {
                        notMovingCratesOnActiveLasers = (tilesInFront.0 as! Floor).laserBeams.first(where: { $0.isHidden && $0.direction == .left }) != nil ? true : false
                    }
                }
            }
            
        default:
            print("Unknown direction")
        }

        return isPlayersPathClear(twoTilesInFrontOfPlayer: tilesInFront) && notMovingCratesOnActiveLasers

    }
    
    func getAdjacentTiles(inDirection dir: Direction) -> (Tile, Tile) {
        var oneTileFromPlayer: Tile!
        var twoTilesFromPlayer: Tile!
        let playerLocation: Point = getPlayerRowAndCol()

        switch dir {
        case .up:
            oneTileFromPlayer = grid[playerLocation.row - 1][playerLocation.col]
            twoTilesFromPlayer = grid[playerLocation.row - 2][playerLocation.col]
        case .down:
            oneTileFromPlayer = grid[playerLocation.row + 1][playerLocation.col]
            twoTilesFromPlayer = grid[playerLocation.row + 2][playerLocation.col]
        case .left:
            oneTileFromPlayer = grid[playerLocation.row][playerLocation.col - 1]
            twoTilesFromPlayer = grid[playerLocation.row][playerLocation.col - 2]
        case .right:
            oneTileFromPlayer = grid[playerLocation.row][playerLocation.col + 1]
            twoTilesFromPlayer = grid[playerLocation.row][playerLocation.col + 2]
        default:
            print("Unknown direction")
        }
        
        return (oneTileFromPlayer, twoTilesFromPlayer)
    }
    
    func isPlayersPathClear(twoTilesInFrontOfPlayer: (Tile, Tile)) -> Bool {
        let oneTileFromPlayer: Tile = twoTilesInFrontOfPlayer.0
        let twoTilesFromPlayer: Tile = twoTilesInFrontOfPlayer.1
        
        // Check if player is 1 tile in front of wall, in front of crate and wall, or in front of 2 crates
        if  oneTileFromPlayer.name == Constants.TileNames.wall.rawValue ||
            (isFloorThatContainsCrate(oneTileFromPlayer) && twoTilesFromPlayer.name == Constants.TileNames.wall.rawValue) ||
            (isFloorThatContainsCrate(oneTileFromPlayer) && isFloorThatContainsCrate(twoTilesFromPlayer)) {
            return false
        }
        
        // Check if player is standing on laserBeam-- if it's hidden, they can move; else, they can't
        if let beams = (oneTileFromPlayer as? Floor)?.laserBeams {
            return beams.filter( { !$0.isHidden } ).count > 0 ? false : true
        }
        
        
        // Also check if player can get hit from multiple sides w/ lasers. Ex, player should not be able to push down here bc would get hit by LP on the right
        // Check for all directions --> Does the crate have a laser beam property?
        //
        //      player
        //      crate    <----- LP
        //
        //       ^
        //       |
        //       LP
        return true
    }
    
    func isFloorThatContainsCrate(_ tile: Tile) -> Bool {
        if let floor = tile as? Floor {
            return floor.crate != nil
        }
        
        return false
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
                let oneTileUp: Floor = (grid[positionOfFloorThatHoldsCrateInFrontOfPlayer.row - 1][positionOfFloorThatHoldsCrateInFrontOfPlayer.col] as! Floor)
                oneTileUp.setCrate(to: floorThatHoldsCrateInFrontofPlayer.crate!)
                oneTileUp.crate?.isOnActiveLaserBeam = oneTileUp.laserBeams.filter( { !$0.isHidden } ).count > 0 ? true : false
                (floorThatHoldsCrateInFrontofPlayer.crate!).moveUp(byNumTiles: 1)
            case .down:
                let oneTileDown: Floor = (grid[positionOfFloorThatHoldsCrateInFrontOfPlayer.row + 1][positionOfFloorThatHoldsCrateInFrontOfPlayer.col] as! Floor)
                oneTileDown.setCrate(to: floorThatHoldsCrateInFrontofPlayer.crate!)
                oneTileDown.crate?.isOnActiveLaserBeam = oneTileDown.laserBeams.filter( { !$0.isHidden } ).count > 0 ? true : false
                (floorThatHoldsCrateInFrontofPlayer.crate!).moveDown(byNumTiles: 1)
            case .left:
                let oneTileLeft: Floor = (grid[positionOfFloorThatHoldsCrateInFrontOfPlayer.row][positionOfFloorThatHoldsCrateInFrontOfPlayer.col - 1] as! Floor)
                oneTileLeft.setCrate(to: floorThatHoldsCrateInFrontofPlayer.crate!)
                oneTileLeft.crate?.isOnActiveLaserBeam = oneTileLeft.laserBeams.filter( { !$0.isHidden } ).count > 0 ? true : false
                (floorThatHoldsCrateInFrontofPlayer.crate!).moveLeft(byNumTiles: 1)
            case .right:
                let oneTileRight: Floor = (grid[positionOfFloorThatHoldsCrateInFrontOfPlayer.row][positionOfFloorThatHoldsCrateInFrontOfPlayer.col + 1] as! Floor)
                oneTileRight.setCrate(to: floorThatHoldsCrateInFrontofPlayer.crate!)
                oneTileRight.crate?.isOnActiveLaserBeam = oneTileRight.laserBeams.filter( { !$0.isHidden } ).count > 0 ? true : false
                print("is crate now on  beam? \(oneTileRight.crate?.isOnActiveLaserBeam)")
                (floorThatHoldsCrateInFrontofPlayer.crate!).moveRight(byNumTiles: 1)
            default:
                print("Unknown direction")
            }
            
            floorThatHoldsCrateInFrontofPlayer.setCrateToNil()
            didMoveCrate = true
        }
    }
    
    // The row and col properties of Floors (and Crates) are not changed at all throughout the game-- only the Floors crate and player properties are
    func movePlayer(inDirection dir: Direction) {
        if !canPlayerMove(inDirection: dir) { SoundPlayer.playSound(.playerCantMove); return }

        didPlayerMove = true

        var oneTileFromPlayer: Tile!
        let playerLocation: Point = getPlayerRowAndCol()
        let playerNode: Player = (grid[playerLocation.row][playerLocation.col] as! Floor).player!
        
        switch dir {
        case .up:
            oneTileFromPlayer = getAdjacentTiles(inDirection: .up).0

            moveCrateIfNeeded(onTile: oneTileFromPlayer, inDirection: .up)
            
            // Set current Floor's player property to nil bc player is moving off of it
            ((grid[playerLocation.row][playerLocation.col]) as! Floor).player!.moveUp(byNumTiles: 1) // Animates player
            ((grid[playerLocation.row][playerLocation.col]) as! Floor).player = nil
        case .down:
            oneTileFromPlayer = getAdjacentTiles(inDirection: .down).0
                
            moveCrateIfNeeded(onTile: oneTileFromPlayer, inDirection: .down)
                
            ((grid[playerLocation.row][playerLocation.col]) as! Floor).player!.moveDown(byNumTiles: 1)
            ((grid[playerLocation.row][playerLocation.col]) as! Floor).player = nil
        case .left:
            oneTileFromPlayer = getAdjacentTiles(inDirection: .left).0
            
            moveCrateIfNeeded(onTile: oneTileFromPlayer, inDirection: .left)
                
            ((grid[playerLocation.row][playerLocation.col]) as! Floor).player!.moveLeft(byNumTiles: 1)
            ((grid[playerLocation.row][playerLocation.col]) as! Floor).player = nil
        case .right:
            oneTileFromPlayer = getAdjacentTiles(inDirection: .right).0
                
            moveCrateIfNeeded(onTile: oneTileFromPlayer, inDirection: .right)
    
            ((grid[playerLocation.row][playerLocation.col]) as! Floor).player!.moveRight(byNumTiles: 1)
            ((grid[playerLocation.row][playerLocation.col]) as! Floor).player = nil
        default:
            print("Unknown direction")
        }
        
        (oneTileFromPlayer as! Floor).player = playerNode // Set tile in front of player (floor) to have player property
    }
}
