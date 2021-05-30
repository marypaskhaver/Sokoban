//
//  SoundPlayer.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 1/21/21.
//

import Foundation
import AVFoundation

class SoundPlayer {
    private static var numberOfStorageSpacesFilled: Int = 0
    private static var arrayOfAudioPlayers: [AVAudioPlayer] = []
    
    static func reset() {
        SoundPlayer.numberOfStorageSpacesFilled = 0
        SoundPlayer.arrayOfAudioPlayers = []
    }
    
    static func playSound(_ sound: String) {
        guard let url = Bundle.main.url(forResource: sound, withExtension: nil) else {
            print("\(sound) url not found")
            return
        }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            // The following line is required for the player to work on iOS 11. Change the file type accordingly
            let player: AVAudioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

//            guard let player = player else { return }
//            player.prepareToPlay()
            player.volume = 1

            if sound != Sound.playerCantMove {
                player.numberOfLoops = -1 // Loop forever
            } else {
                player.prepareToPlay()
                player.play()
                return
            }
            
            SoundPlayer.arrayOfAudioPlayers.append(player)
            player.prepareToPlay()
            
            for player in SoundPlayer.arrayOfAudioPlayers {
                // Play in background
                DispatchQueue.main.async {
                    player.stop()
                    player.play()
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
    
    static func updateLevelMusic(withGridInformation gridInformation: GridInformation) {
        let levelMusicParts: [String] = Tile.constants.getLevelTheme().levelMusicParts
        let numberOfCratesOnStorageTiles = gridInformation.numberOfCratesOnStorageTiles()
                
        if numberOfCratesOnStorageTiles == SoundPlayer.numberOfStorageSpacesFilled {
            return
        }
        
        SoundPlayer.arrayOfAudioPlayers = []
                        
        // The # of storage locations with crates on them has changed
        for musicPart in 0..<numberOfCratesOnStorageTiles {
            // Avoid going out of bounds if I accidentally or by default provide a music theme to a level that consists
            // of less parts than there are storage spaces
            if musicPart < levelMusicParts.count {
                playSound(levelMusicParts[musicPart])
            }
        }
        
        SoundPlayer.numberOfStorageSpacesFilled = numberOfCratesOnStorageTiles
        
    }
}
