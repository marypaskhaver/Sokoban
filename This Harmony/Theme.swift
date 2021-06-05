//
//  Theme.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 4/18/21.
//

import Foundation

class Theme: Equatable {
    var floorImage: String // Floor image that goes underneath crates
    var playerFloorImage: String // Floor image that goes underneath player
    
    var playerImage: String
    var laserBeamImages: [String]
    var laserPointerImages: [String]
    var crateImage: String
    private var name: String
    
    var levelMusicParts: [String]
    
    init(withName name: String, floorImage: String = Constants.TileNames.floor.rawValue, playerFloorImage: String?, playerImage: String = Constants.TileNames.player.rawValue, laserBeamImages: [String] = ["laser_beam_pointing_up"], laserPointerImages: [String] = [Constants.TileNames.laserPointer.rawValue], crateImage: String = Constants.TileNames.crate.rawValue, levelMusicParts: [String] = []) {
        // Change levelMusicParts later to default theme
        self.name = name
        
        self.floorImage = floorImage
        self.playerFloorImage = (playerFloorImage == nil) ? floorImage : playerFloorImage!
        
        self.playerImage = playerImage
        self.laserBeamImages = laserBeamImages
        self.laserPointerImages = laserPointerImages
        self.crateImage = crateImage
        self.levelMusicParts = levelMusicParts
    }
    
    static func == (lhs: Theme, rhs: Theme) -> Bool {
        return lhs.name == rhs.name
    }
    
}

class Default: Theme {
    init() {
        let floorImage: String = Constants.TileNames.floor.rawValue
        super.init(withName: "Default", floorImage: floorImage, playerFloorImage: nil)
    }
}

class Default2: Theme {
    // Temporary-- just seeing if I can use diff images in levels w/ diff themes
    init() {
        let floorImage: String = Constants.TileNames.player.rawValue
        
        super.init(withName: "Default2", floorImage: floorImage, playerFloorImage: nil)
    }
}

class Beach: Theme {
    init(withFloorImage floorImage: String = "beach_floor1", withPlayerFloorImage playerFloorImage: String? = nil, levelMusicParts: [String] = Sound.beachThemeTwoStoragesA) {
        let playerImage: String = "beach_player"
        
        let laserBeamImages: [String] = ["beach_laser_beam_pointing_up", "beach_laser_beam_pointing_down"]
        
        let laserPointerImages: [String] = Beach.getLaserPointerAnimationImages(forLaserPointerWithBaseName: "witch")
        
        let crateImage: String = "beach_crate"
        
        super.init(withName: "Beach", floorImage: floorImage, playerFloorImage: playerFloorImage, playerImage: playerImage, laserBeamImages: laserBeamImages, laserPointerImages: laserPointerImages, crateImage: crateImage, levelMusicParts: levelMusicParts)
    }
    
    private static func getLaserPointerAnimationImages(forLaserPointerWithBaseName name: String) -> [String] {
        var images: [String] = []
        
        for dirLetter in ["u", "d", "l", "r"] {
            images.append(name + "_" + dirLetter + "_1")
            images.append(name + "_" + dirLetter + "_stand")
        }
        
        return images
    }
}

class DarkDimension: Theme {
    init(withFloorImage floorImage: String = "dd_tile002", withPlayerFloorImage playerFloorImage: String? = nil, levelMusicParts: [String] = Sound.darkThemeThreeStoragesA) {
        let playerImage: String = "beach_player"
        
        let laserBeamImages: [String] = ["skull", "skull2"]
        
        let laserPointerImages: [String] = DarkDimension.getLaserPointerAnimationImages(forLaserPointerWithBaseName: "reaper")
        
        let crateImage: String = "beach_crate"
        
        super.init(withName: "Dark Dimension", floorImage: floorImage, playerFloorImage: playerFloorImage, playerImage: playerImage, laserBeamImages: laserBeamImages, laserPointerImages: laserPointerImages, crateImage: crateImage, levelMusicParts: levelMusicParts)
    }
    
    private static func getLaserPointerAnimationImages(forLaserPointerWithBaseName name: String) -> [String] {
        var images: [String] = []
        
        for dirLetter in ["u", "d", "l", "r"] {
            images.append(name + "_" + dirLetter + "_1")
//            images.append(name + "_" + dirLetter + "_2")
            
            if dirLetter == "l" {
                images.append(name + "_l_2")
            }
        }
        
        return images
    }
}
