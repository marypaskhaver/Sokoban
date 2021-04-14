//
//  CrateMover.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 4/11/21.
//

import Foundation

class CrateMover {
    var grid: [[Tile]]
    
    init(withGrid grid: [[Tile]]) {
        self.grid = grid
    }
    
    func moveCrate(onTile tile: Tile, inDirection dir: Direction) {
        let floorThatHoldsCrateInFrontofPlayer: Floor = tile as! Floor
        let positionOfFloorThatHoldsCrateInFrontOfPlayer: GridPoint = GridInformation(withGrid: grid).getRowAndColumnOfFloor(floorNodeInGrid: floorThatHoldsCrateInFrontofPlayer)
        
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
            (floorThatHoldsCrateInFrontofPlayer.crate!).moveRight(byNumTiles: 1)
        default:
            print("Unknown direction")
        }
        
        floorThatHoldsCrateInFrontofPlayer.setCrateToNil()
        
//        return grid?
    }
    
}
