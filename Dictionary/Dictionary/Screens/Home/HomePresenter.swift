//
//  HomePresenter.swift
//  Dictionary
//
//  Created by Melik Demiray on 5.06.2024.
//

import Foundation

// MARK: - HomePresenterProtocol
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

//MARK: Private Functions
    fileprivate func fetchWord(word: String) {
        interactor.fetchWord(word: word) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let result):
                fetchSynonyms(word: word, wordModel: result)
            case .failure(let error):
                self.view.showError(error: error)
            }
        }
    }

    fileprivate func fetchSynonyms(word: String, wordModel: Word) {
        interactor.fetchWordSynonyms(word: word) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let synonyms):
                self.router.navigateToWordDetail(.detail(word: wordModel, synonyms: synonyms))
            case .failure(let error):
                self.view.showError(error: error)
            }
        }
    }
}

// MARK: - HomePresenterProtocol
extension HomePresenter: HomePresenterProtocol {

//MARK: User Defaults
    func deleteRecentWord(at index: Int) {
        var recentWords = getRecentWords()
        recentWords.remove(at: index)
        let userDefaults = UserDefaults.standard
        let key = "recentWords"
        userDefaults.set(recentWords, forKey: key)
        view.reloadTableView()
    }

    func saveRecentWord(word: String) {
        let userDefaults = UserDefaults.standard
        let key = "recentWords"

        var recentWords = userDefaults.stringArray(forKey: key) ?? []

        if let index = recentWords.firstIndex(of: word) {
            recentWords.remove(at: index)
        }

        recentWords.insert(word, at: 0)

        if recentWords.count > 5 {
            recentWords.removeLast()
        }

        userDefaults.set(recentWords, forKey: key)
        view.reloadTableView()
    }

    func viewDidLoad() {
        view.reloadTableView()
    }

    func searchButtonTapped(word: String) {
        fetchWord(word: word)
    }

//MARK: Keyboard
    func keyboardWillShow(withHeight height: CGFloat) {
        view.adjustSearchButton(forKeyboardHeight: height)
    }

    func keyboardWillHide() {
        view.adjustSearchButton(forKeyboardHeight: 0)
    }

//MARK: Getters
    func recentWord(at index: Int) -> String {
        getRecentWords()[index]
    }
    var numberOfRecentWords: Int {
        getRecentWords().count
    }
    func getRecentWords() -> [String] {
        let userDefaults = UserDefaults.standard
        let key = "recentWords"
        return userDefaults.stringArray(forKey: key) ?? []
    }
}

// MARK: - HomeInteractorOutputProtocol
extension HomePresenter: HomeInteractorOutputProtocol {

}
