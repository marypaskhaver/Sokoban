//
//  Constants.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 1/2/21.
//

import Foundation

class Constants {
    let tileSize: Int = 70
    let movementAnimationDuration: TimeInterval = 0.2
    
    enum TileNames: String {
        case floor = "floor"
        case crate = "crate"
        case wall = "wall"
        case player = "player"
        case storage = "storage"
        case laserPointer = "laser_pointer"
        case laserBeam = "laser_beam"
    }
    
    var completeLevels: [Int] = []
    
    var levelThemes: [Int : Theme] = [
        1 : Default(),
        2 : Default2(),
        3 : Beach(),
        4 : Beach(),
        5 : Beach(withFloorImages: ["tile005"])
    ]
    
    var numLevels: Int = 0
    var cdm: CoreDataManager
    
    init(withCoreDataManager cdm: CoreDataManager = CoreDataManager()) {
        let resourceURL = Bundle.main.resourceURL!
        let resourcesContent = (try? FileManager.default.contentsOfDirectory(at: resourceURL, includingPropertiesForKeys: nil)) ?? []
        let levelCount = resourcesContent.filter { $0.lastPathComponent.hasPrefix("Level_") }.count
        
        numLevels = levelCount
        self.cdm = cdm
        
        // Load completeLevels
        let allCompletedLevels: [CompletedLevel] = cdm.fetchAllCompletedLevelsInAscendingOrderAndLowestSteps()

        var uniqueCompleteLevels: [CompletedLevel] = []
        var uniqueCompleteLevelNumbers: [Int] = []

        for level in allCompletedLevels {
            if !uniqueCompleteLevelNumbers.contains(Int(level.levelNumber)) {
                uniqueCompleteLevels.append(level)
                uniqueCompleteLevelNumbers.append(Int(level.levelNumber))
            }
        }
        
        for level in uniqueCompleteLevels {
            if level.lowestSteps < Int32.max {
                completeLevels.append(Int(level.levelNumber))
            }
        }
    }
    
    func getLevelTheme() -> Theme {
        return Tile.constants.levelThemes[CoreDataManager.gameSceneClass.level]!
    }
}
