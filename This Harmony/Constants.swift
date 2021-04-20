//
//  Constants.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 1/2/21.
//

import Foundation

class Constants {
    static let tileSize: Int = 70
    static let movementAnimationDuration: TimeInterval = 0.2
    
    enum TileNames: String {
        case floor = "floor"
        case crate = "crate"
        case wall = "wall"
        case player = "player"
        case storage = "storage"
        case laserPointer = "laser_pointer"
        case laserBeam = "laser_beam"
    }
    
    static var numLevels: Int {
        get {
            let resourceURL = Bundle.main.resourceURL!
            let resourcesContent = (try? FileManager.default.contentsOfDirectory(at: resourceURL, includingPropertiesForKeys: nil)) ?? []
            let levelCount = resourcesContent.filter { $0.lastPathComponent.hasPrefix("Level_") }.count
            
            return levelCount
        }
    }
    
    static var completeLevels: [Int] = []
    
    static var levelThemes: [Int : Theme] = [
        1 : Default(),
        2 : Default2(),
        3 : Beach()
    ]
}
