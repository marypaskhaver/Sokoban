//
//  Theme.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 4/18/21.
//

import Foundation

class Theme: Equatable {
    var floorImage: [String]
    var storageImage: [String]
    
    init(floorImage: [String] = [Constants.TileNames.floor.rawValue], storageImage: [String] = [Constants.TileNames.storage.rawValue]) {
        self.floorImage = floorImage
        self.storageImage = storageImage
    }
    
    static func == (lhs: Theme, rhs: Theme) -> Bool {
        return lhs.floorImage == rhs.floorImage && lhs.storageImage == rhs.storageImage
    }
    
//    var wallImage: String { get }
//    var laserPointerImage: String { get }
//    var laserBeamImage: String { get }
}

class Default: Theme {
    init() {
        let floorImages: [String] = [Constants.TileNames.floor.rawValue]
        let storageImages: [String] = [Constants.TileNames.storage.rawValue]

        super.init(floorImage: floorImages, storageImage: storageImages)
    }
}

class Default2: Theme {
    // Temporary-- just seeing if I can use diff images in levels w/ diff themes
    init() {
        let floorImages: [String] = [Constants.TileNames.player.rawValue]
        let storageImages: [String] = [Constants.TileNames.wall.rawValue]

        super.init(floorImage: floorImages, storageImage: storageImages)
    }
}

class Beach: Theme {
    init() {
        let floorImages: [String] = ["beach_floor1", "beach_floor2", "beach_floor3", "beach_floor4"]
        let storageImages: [String] = [Constants.TileNames.storage.rawValue]
        
        super.init(floorImage: floorImages, storageImage: storageImages)
    }
}
