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
        3 : Beach(withFloorImage: "tile005"),
        4 : Beach(),
        5 : Beach(),
        6 : Beach(levelMusicParts: Sound.beachThemeTwoStoragesB),
        7 : Beach(),
        8 : Beach(),
        9 : Beach(),
        10 : Beach(levelMusicParts: Sound.beachThemeTwoStoragesA),
        11 : DarkDimension(),
        12 : DarkDimension(withFloorImage: "dd_tile023", withPlayerFloorImage: "dd_tile012"),
        13 : DarkDimension(withFloorImage: "dd_tile021"),
        14 : DarkDimension(withPlayerFloorImage: "dd_tile021"),
        15 : DarkDimension(),
        16 : DarkDimension(),
        17 : DarkDimension(withPlayerFloorImage: "dd_tile012"),
        18 : DarkDimension(),
        19 : Jungle(),
        20 : Jungle(),
        21 : Jungle()
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
