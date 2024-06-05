//
//  HomePresenter.swift
//  Dictionary
//
//  Created by Melik Demiray on 5.06.2024.
//

import Foundation

protocol HomePresenterProtocol {
    func viewDidLoad()
    func searchButtonTapped(word: String)
}

final class HomePresenter: HomePresenterProtocol {

    private let view: HomeViewControllerProtocol
    private let router: HomeRouterProtocol
    private let interactor: HomeInteractorProtocol

    init(view: HomeViewControllerProtocol, router: HomeRouterProtocol, interactor: HomeInteractorProtocol) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }

    func viewDidLoad() {
        //view.prepareUI()
    }

    func searchButtonTapped(word: String) {
        interactor.fetchWord(word: word) { [weak self] result in
            switch result {
            case .success(let word):
                self?.router.navigateToWordDetail(word: word)
            case .failure(let error):
                self?.view.showError(error: error)
            }
        }
    }

}
