//
//  DetailPresenter.swift
//  Dictionary
//
//  Created by Melik Demiray on 6.06.2024.
//

import Foundation

protocol DetailPresenterProtocol {
    var clickedButtons: [String] { get }

    func cancelBtnClicked()
    func nounButtonClicked()
    func verbButtonClicked()
    func adjectiveButtonClicked()
    func getCancelBtnStatus() -> Bool
    func getMainButtonTitle() -> String
    func clearTitle()
    func resetFirstClicked()
    func getWordName() -> String
    func getWordPhonetic() -> String
    func getWordMeanings() -> [Meaning]
    func getWordPhonetics() -> [Phonetic]
    func playSound()
}

final class DetailPresenter {

    weak var view: DetailViewControllerProtocol!
    var interactor: DetailInteractorProtocol
    var router: DetailRouterProtocol
    var word: Word?

    private var buttonArray = [String]()
    private var isCancelBtnClicked = false
    private var isNounBtnClicked = false
    private var isVerbBtnClicked = false
    private var isAdjectiveBtnClicked = false
    private var isFirstClicked = false
    private var title = ""

    init(view: DetailViewControllerProtocol, interactor: DetailInteractorProtocol, router: DetailRouterProtocol) {
        self.interactor = interactor
        self.router = router
        self.view = view
    }

}

// MARK: - Private Functions
extension DetailPresenter {
    fileprivate func addToClickedButtons(_ buttons: String) {
        if buttons == "Noun" {
            buttonArray.append("Noun")
        }
        else if buttons == "Verb" {
            buttonArray.append("Verb")
        }
        else if buttons == "Adjective" {
            buttonArray.append("Adjective")
        }
    }

    fileprivate func removeFromClickedButtons(_ buttons: String) {
        if buttons == "Noun" {
            buttonArray.removeAll { $0 == "Noun" }
        }
        else if buttons == "Verb" {
            buttonArray.removeAll { $0 == "Verb" }
        }
        else if buttons == "Adjective" {
            buttonArray.removeAll { $0 == "Adjective" }
        }
    }
}

// MARK: - DetailPresenterProtocol
extension DetailPresenter: DetailPresenterProtocol {
    func playSound() {
        guard let firtAudio = word?.phonetics?.first?.audio else { return }
        guard let secondAudio = word?.phonetics?.last?.audio else { return }

        if firtAudio != "" {
            interactor.playSound(firtAudio)
        } else if secondAudio != "" {
            interactor.playSound(secondAudio)
        } else {
            view.hideSoundButton()
            print("No audio available")
        }
    }

    func getWordName() -> String {
        word?.word ?? ""
    }

    func getWordPhonetic() -> String {
        word?.phonetic ?? ""
    }

    func getWordMeanings() -> [Meaning] {
        word?.meanings ?? [Meaning]()
    }

    func getWordPhonetics() -> [Phonetic] {
        word?.phonetics ?? [Phonetic]()
    }

    func resetFirstClicked() {
        isFirstClicked = false
    }

    func clearTitle() {
        title = ""
    }

    func getMainButtonTitle() -> String {
        title
    }

    var clickedButtons: [String] {
        buttonArray
    }

    func getCancelBtnStatus() -> Bool {
        isCancelBtnClicked
    }

    func cancelBtnClicked() {
        view.hideCancelButton()
        buttonArray.removeAll()
        isCancelBtnClicked = true
        isNounBtnClicked = false
        isVerbBtnClicked = false
        isAdjectiveBtnClicked = false
        view.cancelButtonClicked()
    }

    func nounButtonClicked() {
        view.showCancelButton()
        removeFromClickedButtons("Noun")
        if isFirstClicked { title += ", Noun" } else { title += "Noun"; isFirstClicked = true }
        buttonArray.append("Noun")
        view.hideSelectedButton()
    }

    func verbButtonClicked() {
        view.showCancelButton()
        removeFromClickedButtons("Verb")
        if isFirstClicked { title += ", Verb" } else { title += "Verb"; isFirstClicked = true }
        buttonArray.append("Verb")
        view.hideSelectedButton()
    }

    func adjectiveButtonClicked() {
        view.showCancelButton()
        removeFromClickedButtons("Adjective")
        if isFirstClicked { title += ", Adjective" } else { title += "Adjective"; isFirstClicked = true }
        buttonArray.append("Adjective")
        view.hideSelectedButton()
    }
}

extension DetailPresenter: DetailInteractorOutputProtocol {

}
