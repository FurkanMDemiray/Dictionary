//
//  DetailInteractor.swift
//  Dictionary
//
//  Created by Melik Demiray on 6.06.2024.
//

import Foundation

protocol DetailInteractorProtocol {
    func playSound(_ audio: String)
}

protocol DetailInteractorOutputProtocol {
    // Interactor çıkış protokolleri
}

final class DetailInteractor {
    var presenter: DetailInteractorOutputProtocol!
    var output: DetailInteractorOutputProtocol!

    private var audioManager: AudioManager? = AudioManager.shared

}

extension DetailInteractor: DetailInteractorProtocol {
    func playSound(_ audio: String) {
        audioManager?.startAudio(audio)
    }
}

extension DetailInteractor: DetailInteractorOutputProtocol {
    // Interactor çıkış protokolleri ile ilgili implementasyonlar
}

