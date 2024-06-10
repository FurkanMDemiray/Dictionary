//
//  DetailPresenter.swift
//  Dictionary
//
//  Created by Melik Demiray on 6.06.2024.
//

import Foundation

// MARK: - DetailPresenterProtocol
protocol DetailPresenterProtocol {
    var clickedButtons: [String] { get }
    var partsOfSpeech: [String] { get }
    var definitions: [String] { get }
    var examples: [String] { get }
    var numberOfItems: Int { get }

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
    func getTypes()
    func filtering(_ type: String)
    func getDetailEntity() -> [DetailModel]
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
    private var allNounsDefinitions = [String]()
    private var allVerbsDefinitions = [String]()
    private var allAdjectivesDefinitions = [String]()
    private var allNounsExamples = [String]()
    private var allVerbsExamples = [String]()
    private var allAdjectivesExamples = [String]()
    private var wordTypes = [String]()
    private var detailEntity = [DetailModel]()
    private var filteredDetailEntity = [DetailModel]()

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

    fileprivate func appendWordTypes() {
        for _ in 0..<allNounsDefinitions.count {
            wordTypes.append("Noun")
        }
        for _ in 0..<allVerbsDefinitions.count {
            wordTypes.append("Verb")
        }
        for _ in 0..<allAdjectivesDefinitions.count {
            wordTypes.append("Adjective")
        }
    }

    fileprivate func setDetailEntity() {
        for i in 0..<definitions.count {
            let entity = DetailModel(partOfSpeech: partsOfSpeech[i], definitions: definitions[i], examples: examples[i])
            detailEntity.append(entity)
        }
    }
}

// MARK: - DetailPresenterProtocol
extension DetailPresenter: DetailPresenterProtocol {

    func getDetailEntity() -> [DetailModel] {
        detailEntity
    }

    func filtering(_ type: String) {
        filteredDetailEntity = getDetailEntity()
        if type == "Noun" {
            filteredDetailEntity = detailEntity.filter { $0.partOfSpeech == "Noun" }
        }
        else if type == "Verb" {
            filteredDetailEntity = detailEntity.filter { $0.partOfSpeech == "Verb" }
        }
        else if type == "Adjective" {
            filteredDetailEntity = detailEntity.filter { $0.partOfSpeech == "Adjective" }
        }
        DetailCell.counter = 0
        DetailCell.tmp = ""
        detailEntity.removeAll()
        detailEntity = filteredDetailEntity
        print(detailEntity)
        view.updateView()
    }


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

    var numberOfItems: Int {
        detailEntity.count
    }

    var definitions: [String] {
        let definitions = allNounsDefinitions + allVerbsDefinitions + allAdjectivesDefinitions
        return definitions
    }

    var examples: [String] {
        let examples = allNounsExamples + allVerbsExamples + allAdjectivesExamples
        return examples
    }

    var partsOfSpeech: [String] {
        wordTypes
    }

    func getTypes() {
        guard let meanings = word?.meanings else { return }
        for meaning in meanings {
            guard let definitions = meaning.definitions else { return }
            if meaning.partOfSpeech == "noun" {
                for definition in definitions {
                    allNounsDefinitions.append(definition.definition ?? "")
                }
                for example in definitions {
                    allNounsExamples.append(example.example ?? "")
                }
            }
            else if meaning.partOfSpeech == "verb" {
                for definition in definitions {
                    allVerbsDefinitions.append(definition.definition ?? "")
                }
                for example in definitions {
                    allVerbsExamples.append(example.example ?? "")
                }
            }
            else if meaning.partOfSpeech == "adjective" {
                for definition in definitions {
                    allAdjectivesDefinitions.append(definition.definition ?? "")
                }
                for example in definitions {
                    allAdjectivesExamples.append(example.example ?? "")
                }
            }
        }
        appendWordTypes()
        setDetailEntity()
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

//MARK: - Button Functions
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
        filtering("Noun")
    }

    func verbButtonClicked() {
        view.showCancelButton()
        removeFromClickedButtons("Verb")
        if isFirstClicked { title += ", Verb" } else { title += "Verb"; isFirstClicked = true }
        buttonArray.append("Verb")
        view.hideSelectedButton()
        filtering("Verb")
    }

    func adjectiveButtonClicked() {
        view.showCancelButton()
        removeFromClickedButtons("Adjective")
        if isFirstClicked { title += ", Adjective" } else { title += "Adjective"; isFirstClicked = true }
        buttonArray.append("Adjective")
        view.hideSelectedButton()
        filtering("Adjective")
    }
}

extension DetailPresenter: DetailInteractorOutputProtocol {

}
