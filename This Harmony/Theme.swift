//
//  Theme.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 4/18/21.
//

import Foundation

protocol Theme {
    var floorImage: [String] { get }
    var storageImage: [String] { get }
//    var wallImage: String { get }
//    var laserPointerImage: String { get }
//    var laserBeamImage: String { get }
}

class Default: Theme {
    var floorImage: [String] = [Constants.TileNames.floor.rawValue]
    var storageImage: [String] = [Constants.TileNames.storage.rawValue]
}

class Default2: Theme {
    // Temporary-- just seeing if I can use diff images in levels w/ diff themes
    var floorImage: [String] = [Constants.TileNames.player.rawValue]
    var storageImage: [String] = [Constants.TileNames.wall.rawValue]
}

class Beach: Theme {
    var floorImage: [String] = ["beach_floor1", "beach_floor2", "beach_floor3", "beach_floor4"]
    var storageImage: [String] = [Constants.TileNames.storage.rawValue]
}
