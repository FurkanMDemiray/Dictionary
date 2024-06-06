//
//  HomePresenter.swift
//  Dictionary
//
//  Created by Melik Demiray on 5.06.2024.
//

import Foundation

protocol HomePresenterProtocol: AnyObject {
    var numberOfRecentWords: Int { get }

    func viewDidLoad()
    func searchButtonTapped(word: String)
    func keyboardWillShow(withHeight height: CGFloat)
    func keyboardWillHide()
    func saveRecentWord(word: String)
    func getRecentWords() -> [String]
    func recentWord(at index: Int) -> String
    func deleteRecentWord(at index: Int)
}

final class HomePresenter {

    weak var view: HomeViewControllerProtocol!
    var interactor: HomeInteractorProtocol
    var router: HomeRouterProtocol

    init(view: HomeViewControllerProtocol, router: HomeRouterProtocol, interactor: HomeInteractorProtocol) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
}

// MARK: - HomePresenterProtocol
extension HomePresenter: HomePresenterProtocol {

    func deleteRecentWord(at index: Int) {
        var recentWords = getRecentWords()
        recentWords.remove(at: index)
        let userDefaults = UserDefaults.standard
        let key = "recentWords"
        userDefaults.set(recentWords, forKey: key)
        view.updateView()
    }

    func recentWord(at index: Int) -> String {
        getRecentWords()[index]
    }

    var numberOfRecentWords: Int {
        getRecentWords().count
    }

    func saveRecentWord(word: String) {
        let userDefaults = UserDefaults.standard
        let key = "recentWords"

        // Önce mevcut kelimeleri alın
        var recentWords = userDefaults.stringArray(forKey: key) ?? []

        // Eğer kelime zaten mevcutsa, onu kaldır
        if let index = recentWords.firstIndex(of: word) {
            recentWords.remove(at: index)
        }

        // Yeni kelimeyi başa ekleyin
        recentWords.insert(word, at: 0)

        // Eğer kelime sayısı 5'i geçtiyse, son kelimeyi kaldırın
        if recentWords.count > 5 {
            recentWords.removeLast()
        }

        // Güncellenmiş kelime dizisini kaydedin
        userDefaults.set(recentWords, forKey: key)
        view.updateView()
    }

    func getRecentWords() -> [String] {
        let userDefaults = UserDefaults.standard
        let key = "recentWords"
        return userDefaults.stringArray(forKey: key) ?? []
    }

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
                self.router.navigateToWordDetail(.detail(source: word))
            case .failure(let error):
                self.view.showError(error: error)
            }
        }
    }
}

// MARK: - HomeInteractorOutputProtocol
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
