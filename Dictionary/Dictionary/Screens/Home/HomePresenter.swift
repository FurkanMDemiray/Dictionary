//
//  HomePresenter.swift
//  Dictionary
//
//  Created by Melik Demiray on 5.06.2024.
//

import Foundation

protocol HomePresenterProtocol: AnyObject {
    func viewDidLoad()
    func searchButtonTapped(word: String)
    func keyboardWillShow(withHeight height: CGFloat)
    func keyboardWillHide()
}

final class HomePresenter {

    weak var view: HomeViewControllerProtocol!
    var router: HomeRouterProtocol
    var interactor: HomeInteractorProtocol

    init(view: HomeViewControllerProtocol, router: HomeRouterProtocol, interactor: HomeInteractorProtocol) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
}

extension HomePresenter: HomePresenterProtocol {
    func keyboardWillShow(withHeight height: CGFloat) {
        view.adjustSearchButton(forKeyboardHeight: height)
    }

    func keyboardWillHide() {
        view.adjustSearchButton(forKeyboardHeight: 0)
    }

    func viewDidLoad() {
        view.updateView()
    }

    func searchButtonTapped(word: String) {
        interactor.fetchWord(word: word) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let word):
                self.router.navigateToWordDetail(word: word)
            case .failure(let error):
                self.view.showError(error: error)
            }
        }
    }
}

extension HomePresenter: HomeInteractorOutputProtocol {

    func handleWordResult(_ result: Result<Word, Error>) {
        switch result {
        case .success(let word):
            //view.updateView(with: word)
            print(word)
        case .failure(let error):
            view.showError(error: error)
        }
    }

}
