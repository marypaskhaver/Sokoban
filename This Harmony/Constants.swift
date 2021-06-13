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
        1 : Beach(withFloorImage: "tile005", levelMusicParts: Sound.beachThemeFourStoragesA),
        2 : Beach(levelMusicParts: Sound.beachThemeOneStorageA),
        3 : Beach(levelMusicParts: Sound.beachThemeTwoStoragesC),
        4 : Beach(levelMusicParts: Sound.beachThemeTwoStoragesB),
        5 : Beach(levelMusicParts: Sound.beachThemeThreeStoragesA),
        6 : Beach(levelMusicParts: Sound.beachThemeThreeStoragesB),
        7 : Beach(levelMusicParts: Sound.beachThemeThreeStoragesC),
        8 : Beach(levelMusicParts: Sound.beachThemeThreeStoragesD),
        9 : DarkDimension(),
        10 : DarkDimension(withFloorImage: "dd_tile023", withPlayerFloorImage: "dd_tile012"),
        11 : DarkDimension(withFloorImage: "dd_tile021"),
        12 : DarkDimension(withPlayerFloorImage: "dd_tile021"),
        13 : DarkDimension(),
        14 : DarkDimension(),
        15 : DarkDimension(withPlayerFloorImage: "dd_tile012"),
        16 : DarkDimension(),
        17 : Jungle(levelMusicParts: Sound.jungleThemeTwoStoragesA),
        18 : Jungle(),
        19 : Jungle(),
        20 : Jungle(),
        21 : Jungle(levelMusicParts: Sound.jungleThemeOneStorageA),
        22 : Jungle(withPlayerFloorImage: "j_tile108"),
        23 : Jungle(),
        24 : Jungle()
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
