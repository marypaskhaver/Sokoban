//
//  Theme.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 4/18/21.
//

import Foundation

class Theme: Equatable {
    var floorImage: String // Same floor image goes underneath player and all crates
    var playerImage: String
    var laserBeamImages: [String]
    var crateImage: String
    
    init(floorImage: String = Constants.TileNames.floor.rawValue, playerImage: String = Constants.TileNames.player.rawValue, laserBeamImages: [String] = ["laser_beam_pointing_up"], crateImage: String = Constants.TileNames.crate.rawValue) {
        self.floorImage = floorImage
        self.playerImage = playerImage
        self.laserBeamImages = laserBeamImages
        self.crateImage = crateImage
    }
    
    static func == (lhs: Theme, rhs: Theme) -> Bool {
        return lhs.floorImage == rhs.floorImage
    }
    
}

class Default: Theme {
    init() {
        let floorImage: String = Constants.TileNames.floor.rawValue

        super.init(floorImage: floorImage)
    }
}

class Default2: Theme {
    // Temporary-- just seeing if I can use diff images in levels w/ diff themes
    init() {
        let floorImage: String = Constants.TileNames.player.rawValue
        
        super.init(floorImage: floorImage)
    }
}

class Beach: Theme {
    init(withFloorImage floorImage: String = "beach_floor1") {
        let playerImage: String = "beach_player"
        let laserBeamImages: [String] = ["beach_laser_beam_pointing_up", "beach_laser_beam_pointing_down"]
        let crateImage: String = "beach_crate"
        
        super.init(floorImage: floorImage, playerImage: playerImage, laserBeamImages: laserBeamImages, crateImage: crateImage)
    }
}
