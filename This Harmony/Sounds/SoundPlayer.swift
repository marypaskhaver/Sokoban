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
            
            DispatchQueue.main.async {
                player.prepareToPlay()
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
     
    // Only for Sound.playerCantMove right now
    func playSound(_ sound: String) {
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
    
    func playAudioPlayers(upToIndex ind: Int, withGridInformation gridInformation: GridInformation) {
        let numberOfCratesOnStorageTiles = gridInformation.numberOfCratesOnStorageTiles()

        for i in 0..<numberOfCratesOnStorageTiles {
            SoundPlayer.arrayOfAudioPlayers[i].stop()
        }
        
        for i in 0..<ind {
            SoundPlayer.arrayOfAudioPlayers[i].currentTime = 0
            SoundPlayer.arrayOfAudioPlayers[i].play()
        }
    }
    
    func updateLevelMusic(withGridInformation gridInformation: GridInformation) {
        let numberOfCratesOnStorageTiles = gridInformation.numberOfCratesOnStorageTiles()
        
        if SoundPlayer.numberOfStorageSpacesFilled != numberOfCratesOnStorageTiles {
            SoundPlayer.numberOfStorageSpacesFilled = numberOfCratesOnStorageTiles
        } else {
            return
        }
            
        playAudioPlayers(upToIndex: numberOfCratesOnStorageTiles, withGridInformation: gridInformation)
    }
}
