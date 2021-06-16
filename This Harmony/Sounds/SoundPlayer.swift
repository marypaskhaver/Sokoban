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
    
    init() {
        // Load all levelMusicParts into arrayOfAudioPlayers
        let levelMusicParts: [String] = Tile.constants.getLevelTheme().levelMusicParts
        
        for part in levelMusicParts {
            addToAudioPlayers(part)
        }
    }
    
    func reset() {
        SoundPlayer.numberOfStorageSpacesFilled = 0
        SoundPlayer.arrayOfAudioPlayers = []
        SoundPlayer.currentPlayer = nil
    }
    
    func addToAudioPlayers(_ sound: String) {
        guard let url = Bundle.main.url(forResource: sound, withExtension: "mp3") else {
            print("\(sound) url not found")
            return
        }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            // The following line is required for the player to work on iOS 11. Change the file type accordingly
            SoundPlayer.currentPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            guard let player = SoundPlayer.currentPlayer else { return }

            player.volume = 1
            player.numberOfLoops = -1 // Loop forever
            
            SoundPlayer.arrayOfAudioPlayers.append(player)
            
            // Play in the bg / off of main thread
            DispatchQueue.main.async {
                player.prepareToPlay()
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
     
    func playPlayerCantMoveSound() {
        let sound: String = Sound.playerCantMove
        
        guard let url = Bundle.main.url(forResource: sound, withExtension: "mp3") else {
            print("\(sound) url not found")
            return
        }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            // The following line is required for the player to work on iOS 11. Change the file type accordingly
            SoundPlayer.currentPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            guard let player = SoundPlayer.currentPlayer else { return }

            player.volume = 1

            DispatchQueue.main.async {
                player.prepareToPlay()
                player.play()
            }
                        
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
    
    // Stop all players in arrayOfAudioPlayers, then only play as many as there are filled storage spots in the level
    func playAudioPlayers(upToIndex ind: Int) {
        for i in 0..<SoundPlayer.arrayOfAudioPlayers.count {
            SoundPlayer.arrayOfAudioPlayers[i].stop()
        }
        
        for i in 0..<ind {
            let player = SoundPlayer.arrayOfAudioPlayers[i]
            player.currentTime = 0
            player.volume = 1
            
            DispatchQueue.main.async {
                player.play()
            }
        }
    }
    
    func updateLevelMusic(withGridInformation gridInformation: GridInformation) {
        let numberOfCratesOnStorageTiles = gridInformation.numberOfCratesOnStorageTiles()
        
        if SoundPlayer.numberOfStorageSpacesFilled != numberOfCratesOnStorageTiles {
            SoundPlayer.numberOfStorageSpacesFilled = numberOfCratesOnStorageTiles
        } else {
            return
        }
            
        playAudioPlayers(upToIndex: numberOfCratesOnStorageTiles)
    }
}
