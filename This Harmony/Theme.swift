//
//  Theme.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 4/18/21.
//

import Foundation

protocol Theme {
    var floorImage: String { get }
//    var wallImage: String { get }
//    var laserPointerImage: String { get }
//    var laserBeamImage: String { get }
}

class Default: Theme {
    var floorImage: String = Constants.TileNames.floor.rawValue
}

class Default2: Theme {
    // Temporary-- just seeing if I can use diff image for floor in levels w/ diff themes
    var floorImage: String = Constants.TileNames.player.rawValue
}
