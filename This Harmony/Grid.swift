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
    var childrenToAddToView: [SKNode] = [SKNode]()
    
    init(withChildren children: [SKNode]) {
        var arrayOfNodes: [Tile] = []
        
        for child in children {
            // A player and crate will always be standing on a floor, so you can add them normally to the arrayOfNodes and just remember they're on Floor tiles;
            // Maybe create Floor tiles underneath them.
            child.position = CGPoint(x: child.getRoundedX(), y: child.getRoundedY())
            arrayOfNodes.append(child as! Tile)
        }
        
        arrayOfNodes = arrayOfNodes.sorted(by: { $0.frame.midX < $1.frame.midX })
        arrayOfNodes = arrayOfNodes.sorted(by: { $0.frame.midY > $1.frame.midY })
                
        grid = arrayOfNodes.chunked(into: 12)
        
        for r in grid {
            var row = r
            row = row.sorted(by: { $0.frame.midX < $1.frame.midX })
        }
        
        assignNodesRowsAndColumns()
        putFloorsUnderPlayerAndCrates()
    }
    
    func assignNodesRowsAndColumns() {
        for row in 0..<grid.count {
            for col in 0..<grid[row].count {
                let tile: Tile = grid[row][col] // Every element is at least of type Tile
                tile.row = row
                tile.column = col
            }
        }
    }
    
    func putFloorsUnderPlayerAndCrates() {
        for row in 0..<grid.count {
            for col in 0..<grid[row].count {
                if grid[row][col].name == "player" {
                    let player: Player = grid[row][col] as! Player
                    
                    // Replace w/ Floor tile
                    grid[row][col] = Floor(texture: SKTexture(imageNamed: "floor"), name: "floor", row: row, column: col)
                    (grid[row][col] as! Floor).player = player

                    childrenToAddToView.append(grid[row][col])
                    
                    self.player = player
                } else if grid[row][col].name == "crate" {
                    let crate: Crate = grid[row][col] as! Crate
                    
                    // Replace w/ Crate tile
                    grid[row][col] = Floor(texture: SKTexture(imageNamed: "floor"), name: "floor", row: row, column: col)
                    (grid[row][col] as! Floor).crate = crate
                    
                    childrenToAddToView.append(grid[row][col])
                }
                
            }
        }
    }
    
    func printGrid() {
        for row in grid {
            for node in row {
                print(node.name, node.row, node.column)
                
                if node.name == "floor" {
                    if (node as! Floor).player != nil {
                        print("has player")
                    } else if (node as! Floor).crate != nil {
                        print("has crate")
                    }
                }
            }
            print()
        }
    }
    
    func canPlayerMove(inDirection dir: Direction) -> Bool {
        switch dir {
        case .up:
            if player?.row == 1 { print("In row 1, can't move up"); return false }
            let tilesInFront = getAdjacentTiles(inDirection: .up)
            return isPlayersPathClear(twoTilesInFrontOfPlayer: tilesInFront)
        case .down:
            if player?.row == 6 { print("In row 6, can't move down"); return false }
            let tilesInFront = getAdjacentTiles(inDirection: .down)
            return isPlayersPathClear(twoTilesInFrontOfPlayer: tilesInFront)
        case .left:
            if player?.column == 1 { print("In col 1, can't move left"); return false }
            let tilesInFront = getAdjacentTiles(inDirection: .left)
            return isPlayersPathClear(twoTilesInFrontOfPlayer: tilesInFront)
        case .right:
            if player?.column == 10 { print("In col 10, can't move right"); return false }
            let tilesInFront = getAdjacentTiles(inDirection: .right)
            return isPlayersPathClear(twoTilesInFrontOfPlayer: tilesInFront)
        default:
            return false
        }
    }
    
    func getAdjacentTiles(inDirection dir: Direction) -> (Tile, Tile) {
        var oneTileFromPlayer: Tile!
        var twoTilesFromPlayer: Tile!
        
        switch dir {
        case .up:
            oneTileFromPlayer = grid[player!.row - 1][player!.column]
            twoTilesFromPlayer = grid[player!.row - 2][player!.column]
            break
        case .down:
            oneTileFromPlayer = grid[player!.row + 1][player!.column]
            twoTilesFromPlayer = grid[player!.row + 2][player!.column]
            break
        case .left:
            oneTileFromPlayer = grid[player!.row][player!.column - 1]
            twoTilesFromPlayer = grid[player!.row][player!.column - 2]
            break
        case .right:
            oneTileFromPlayer = grid[player!.row][player!.column + 1]
            twoTilesFromPlayer = grid[player!.row][player!.column + 2]
            break
        default:
            print("Unknown direction")
        }
        
        return (oneTileFromPlayer, twoTilesFromPlayer)
    }
    
    func isPlayersPathClear(twoTilesInFrontOfPlayer: (Tile, Tile)) -> Bool {
        let oneTileFromPlayer: Tile = twoTilesInFrontOfPlayer.0
        let twoTilesFromPlayer: Tile = twoTilesInFrontOfPlayer.1
        
        if oneTileFromPlayer.name == "wall" ||
            (isFloorThatContainsCrate(oneTileFromPlayer) && twoTilesFromPlayer.name == "wall") ||
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
    
    func movePlayer(inDirection dir: Direction) {
        switch dir {
        case .up:
            if canPlayerMove(inDirection: .up) {
                let oneTileFromPlayer: Tile = getAdjacentTiles(inDirection: .up).0
                
                if isFloorThatContainsCrate(oneTileFromPlayer) {
                    let floorThatHoldsCrateInFrontofPlayer: Floor = oneTileFromPlayer as! Floor
                    
                    (grid[oneTileFromPlayer.row - 1][oneTileFromPlayer.column] as! Floor).crate = floorThatHoldsCrateInFrontofPlayer.crate as! Crate
                    (floorThatHoldsCrateInFrontofPlayer.crate as! Crate).moveUp(byNumTiles: 1)
                    floorThatHoldsCrateInFrontofPlayer.crate = nil
                }
                
                ((grid[player!.row][player!.column]) as! Floor).player = nil
                player?.row -= 1
                (oneTileFromPlayer as! Floor).player = player
                player?.moveUp(byNumTiles: 1)
            }
            
            break
        case .down:
            if canPlayerMove(inDirection: .down) {
                let oneTileFromPlayer: Tile = getAdjacentTiles(inDirection: .down).0
                
                // If there's a crate, update its properties and move it
                if isFloorThatContainsCrate(oneTileFromPlayer) {
                    // Update grid properties: Set current Floor item that the crate is on to not have a crate property; move the crate property to the
                    // square immediately below the current Floor.
                    let floorThatHoldsCrateInFrontofPlayer: Floor = oneTileFromPlayer as! Floor
                    
                    (grid[oneTileFromPlayer.row + 1][oneTileFromPlayer.column] as! Floor).crate = floorThatHoldsCrateInFrontofPlayer.crate as! Crate
                    (floorThatHoldsCrateInFrontofPlayer.crate as! Crate).moveDown(byNumTiles: 1)
                    floorThatHoldsCrateInFrontofPlayer.crate = nil
                }
                
                ((grid[player!.row][player!.column]) as! Floor).player = nil // Set current Floor's player property to nil bc player is moving off of it
                player?.row += 1 // Inc player's row
                (oneTileFromPlayer as! Floor).player = player // Set tile in front of player (floor) to have player property
                player?.moveDown(byNumTiles: 1) // Animate player
            }
            
            break
        case .left:
            if canPlayerMove(inDirection: .left) {
                let oneTileFromPlayer: Tile = getAdjacentTiles(inDirection: .left).0
                
                if isFloorThatContainsCrate(oneTileFromPlayer) {
                    let floorThatHoldsCrateInFrontofPlayer: Floor = oneTileFromPlayer as! Floor
                    
                    (grid[oneTileFromPlayer.row][oneTileFromPlayer.column - 1] as! Floor).crate = floorThatHoldsCrateInFrontofPlayer.crate as! Crate
                    (floorThatHoldsCrateInFrontofPlayer.crate as! Crate).moveLeft(byNumTiles: 1)
                    floorThatHoldsCrateInFrontofPlayer.crate = nil
                }
                
                ((grid[player!.row][player!.column]) as! Floor).player = nil
                player?.column -= 1
                (oneTileFromPlayer as! Floor).player = player
                player?.moveLeft(byNumTiles: 1)
            }
            
            break
        case .right:
            if canPlayerMove(inDirection: .right) {
                let oneTileFromPlayer: Tile = getAdjacentTiles(inDirection: .right).0
                
                if isFloorThatContainsCrate(oneTileFromPlayer) {
                    let floorThatHoldsCrateInFrontofPlayer: Floor = oneTileFromPlayer as! Floor
                    
                    (grid[oneTileFromPlayer.row][oneTileFromPlayer.column + 1] as! Floor).crate = floorThatHoldsCrateInFrontofPlayer.crate as! Crate
                    (floorThatHoldsCrateInFrontofPlayer.crate as! Crate).moveRight(byNumTiles: 1)
                    floorThatHoldsCrateInFrontofPlayer.crate = nil
                }
                
                ((grid[player!.row][player!.column]) as! Floor).player = nil
                player?.column += 1
                (oneTileFromPlayer as! Floor).player = player
                player?.moveRight(byNumTiles: 1)
            }
                        
            break
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
