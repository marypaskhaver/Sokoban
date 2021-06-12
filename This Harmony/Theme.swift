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
    
    init(withName name: String, floorImage: String = Constants.TileNames.floor.rawValue, playerFloorImage: String?, playerImage: String = Constants.TileNames.player.rawValue, laserBeamImages: [String] = ["laser_beam_pointing_up"], laserPointerImages: [String] = [Constants.TileNames.laserPointer.rawValue], crateImage: String = "barrel", levelMusicParts: [String] = []) {
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
    
    // If what's in UserDefaults conflicts w/ the current playerImage, change current playerImage to what's in UserDefaults
    func updatePlayerImageIfNeeded() {
        if let userChosenPlayerImage = defaults.string(forKey: "userChosenPlayerImage") {
            self.playerImage = userChosenPlayerImage
        }
    }
    
}

class Beach: Theme {
    init(withPlayerImage playerImage: String = "louise", withFloorImage floorImage: String = "beach_floor1", withPlayerFloorImage playerFloorImage: String? = nil, levelMusicParts: [String] = Sound.beachThemeTwoStoragesA) {
        let laserBeamImages: [String] = ["beach_laser_beam_pointing_up", "beach_laser_beam_pointing_down"]
        
        let laserPointerImages: [String] = Beach.getLaserPointerAnimationImages(forLaserPointerWithBaseName: "witch")
                
        super.init(withName: "Beach", floorImage: floorImage, playerFloorImage: playerFloorImage, playerImage: playerImage, laserBeamImages: laserBeamImages, laserPointerImages: laserPointerImages, levelMusicParts: levelMusicParts)
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
    init(withPlayerImage playerImage: String = "louise", withFloorImage floorImage: String = "dd_tile002", withPlayerFloorImage playerFloorImage: String? = nil, levelMusicParts: [String] = Sound.darkThemeThreeStoragesA) {
        
        let laserBeamImages: [String] = ["skull", "skull2"]
        
        let laserPointerImages: [String] = DarkDimension.getLaserPointerAnimationImages(forLaserPointerWithBaseName: "reaper")
                
        super.init(withName: "Dark Dimension", floorImage: floorImage, playerFloorImage: playerFloorImage, playerImage: playerImage, laserBeamImages: laserBeamImages, laserPointerImages: laserPointerImages, levelMusicParts: levelMusicParts)
    }
    
    private static func getLaserPointerAnimationImages(forLaserPointerWithBaseName name: String) -> [String] {
        var images: [String] = []
        
        for dirLetter in ["u", "d", "l", "r"] {
            images.append(name + "_" + dirLetter + "_1")
//            images.append(name + "_" + dirLetter + "_2")
            
            if dirLetter == "l" || dirLetter == "r" {
                images.append(name + "_" + dirLetter + "_2")
            }
        }
        
        return images
    }
}

class Jungle: Theme {
    init(withPlayerImage playerImage: String = "delia", withFloorImage floorImage: String = "j_tile105", withPlayerFloorImage playerFloorImage: String? = nil, levelMusicParts: [String] = Sound.darkThemeThreeStoragesA) {
        
        let laserPointerImages: [String] = ["bard_d_1", "bard_d_2", "bard_d_3", "bard_d_4",
        "bard_u_1", "bard_l_1", "bard_r_1"] // All other images except the _d_ ones don't exist, but I need all directions for code to work for now
                
        var laserBeamImages: [String] = []
        let randRange = Int.random(in: 3..<9)
        
        for num in 1..<randRange {
            laserBeamImages.append("jungle_laser_beam_\(num)")
        }

        super.init(withName: "Jungle", floorImage: floorImage, playerFloorImage: playerFloorImage, playerImage: playerImage, laserBeamImages: laserBeamImages, laserPointerImages: laserPointerImages, levelMusicParts: levelMusicParts)
    }
}
