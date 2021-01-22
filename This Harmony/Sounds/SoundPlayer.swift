//
//  SoundPlayer.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 1/21/21.
//

import Foundation
import AVFoundation

class SoundPlayer {
    private static var player: AVAudioPlayer!
    
    static func playSound(_ sound: Sound) {
        guard let url = Bundle.main.url(forResource: Sound.playerCantMove.rawValue, withExtension: nil) else {
            print("\(sound.rawValue) url not found")
            return
        }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            // The following line is required for the player to work on iOS 11. Change the file type accordingly
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            guard let player = player else { return }
            player.prepareToPlay()
            player.volume = 1
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
}
