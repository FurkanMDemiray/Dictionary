//
//  DetailPresenter.swift
//  Dictionary
//
//  Created by Melik Demiray on 6.06.2024.
//

import Foundation

protocol DetailPresenterProtocol {

}

final class DetailPresenter {

    weak var view: DetailViewControllerProtocol!
    var interactor: DetailInteractorProtocol
    var router: DetailRouterProtocol


    init(view: DetailViewControllerProtocol, interactor: DetailInteractorProtocol, router: DetailRouterProtocol) {
        self.interactor = interactor
        self.router = router
        self.view = view
    }

}

// MARK: - DetailPresenterProtocol
extension DetailPresenter: DetailPresenterProtocol {

}

extension DetailPresenter: DetailInteractorOutputProtocol {

}
