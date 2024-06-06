//
//  DetailInteractor.swift
//  Dictionary
//
//  Created by Melik Demiray on 6.06.2024.
//

import Foundation

protocol DetailInteractorProtocol {
    // Interactor ile ilgili protokoller
}

protocol DetailInteractorOutputProtocol {
    // Interactor çıkış protokolleri
}

final class DetailInteractor {

    var presenter: DetailInteractorOutputProtocol!
    var output: DetailInteractorOutputProtocol!

}

extension DetailInteractor: DetailInteractorProtocol {
    // Interactor ile ilgili implementasyonlar
}

extension DetailInteractor: DetailInteractorOutputProtocol {
    // Interactor çıkış protokolleri ile ilgili implementasyonlar
}

