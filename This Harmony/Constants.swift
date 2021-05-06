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
        3 : Beach()
    ]
    
    var numLevels: Int = 0
    
    init() {
        let resourceURL = Bundle.main.resourceURL!
        let resourcesContent = (try? FileManager.default.contentsOfDirectory(at: resourceURL, includingPropertiesForKeys: nil)) ?? []
        let levelCount = resourcesContent.filter { $0.lastPathComponent.hasPrefix("Level_") }.count
        
        numLevels = levelCount
        
        // Load completeLevels
        let allCompletedLevels: [CompletedLevel] = CoreDataManager().fetchAllCompletedLevelsInAscendingOrderAndLowestSteps()
        print("ALL COMPLETED LEVELS")
        for level in allCompletedLevels {
            print("Level! Number: \(level.levelNumber), steps: \(level.lowestSteps)")
        }
        
        print("----------------------------------------------------------------")
        
        print("UNIQUE LEVELS")
        var uniqueCompleteLevels: [CompletedLevel] = []
        var uniqueCompleteLevelNumbers: [Int] = []

        for level in allCompletedLevels {
            if !uniqueCompleteLevelNumbers.contains(Int(level.levelNumber)) {
                uniqueCompleteLevels.append(level)
                uniqueCompleteLevelNumbers.append(Int(level.levelNumber))
                print("Unique level found! Number: \(level.levelNumber)")
            }
        }
        
        print("----------------------------------------------------------------")
        
        for level in uniqueCompleteLevels {
            if level.lowestSteps < Int32.max {
                completeLevels.append(Int(level.levelNumber))
            }
        }
    }
}
