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
    private static var currentPlayer: AVAudioPlayer!
    // Have to init var outside of playSound to avoid AudioQueueInternalNotifyRunning / error before everything's
    // set up correctly
    
    static func reset() {
        SoundPlayer.numberOfStorageSpacesFilled = 0
        SoundPlayer.arrayOfAudioPlayers = []
        SoundPlayer.currentPlayer = nil
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
            currentPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            guard let player = currentPlayer else { return }

            player.volume = 1

            if sound == Sound.playerCantMove {
                DispatchQueue.main.async {
                    player.prepareToPlay()
                    player.play()
                }
                
                return
            }
            
            if sound != Sound.playerCantMove {
                player.numberOfLoops = -1 // Loop forever
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
        
//         A crate that was previously on a storage location has now been moved off. So, stop playing the very last musicPart / player that was added to arrayOfAudioPlayers
        if numberOfCratesOnStorageTiles < SoundPlayer.numberOfStorageSpacesFilled {
            if let lastPlayer: AVAudioPlayer = SoundPlayer.arrayOfAudioPlayers.popLast() {
                lastPlayer.stop()
            }
            
            SoundPlayer.numberOfStorageSpacesFilled = numberOfCratesOnStorageTiles
            return
        }
        
        // Either the level hasn't started (each are 0) or nothing's changed (player has moved but not pushed a crate), so can return early
        if numberOfCratesOnStorageTiles == SoundPlayer.numberOfStorageSpacesFilled {
            return
        }
                
        // Return early if the number of storage spaces filled is equal to the # of music parts. Since numberOfStorageSpacesFilled right now holds the prev # of storage spaces filled, that means that any subsequent storage filled will be greater than the music parts in the level. Hence, those parts will not play; you will not even affects the arrayOfAudioPlayers
        if SoundPlayer.numberOfStorageSpacesFilled >= levelMusicParts.count {
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
