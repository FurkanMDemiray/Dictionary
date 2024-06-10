//
//  AudioManager.swift
//  Dictionary
//
//  Created by Melik Demiray on 8.06.2024.
//

import Foundation
import AVFoundation

final class AudioManager {

    static let shared = AudioManager()

    private var player: AVPlayer?

    private var session = AVAudioSession.sharedInstance()

    private init() { }

    private func activateSession() {
        do {
            try session.setCategory(
                    .playback,
                mode: .default,
                options: []
            )
        } catch _ { }

        do {
            try session.setActive(true, options: .notifyOthersOnDeactivation)
        } catch _ { }

        do {
            try session.overrideOutputAudioPort(.speaker)
        } catch _ { }
    }

    func startAudio(_ audio: String) {
        activateSession()

        let url = URL(string: audio)
        guard let url else { print("Url not found!!!"); return }
        let playerItem: AVPlayerItem = AVPlayerItem(url: url)

        if let player = player {
            player.replaceCurrentItem(with: playerItem)
        } else {
            player = AVPlayer(playerItem: playerItem)
        }

        if let player = player {
            player.play()
        }
    }
}
