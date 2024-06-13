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
    func setAllTypesOfWord()
    func filtering(_ type: String)
    func getDetailEntity() -> [DetailModel]
    func getSynonyms() -> [String]
    func synonmButtonClick(word: String)
}


final class DetailPresenter {

//MARK: - Variables
    weak var view: DetailViewControllerProtocol!
    var interactor: DetailInteractorProtocol
    var router: DetailRouterProtocol
    var word: Word?
    var synonyms: [SynoymModel]?

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
    private var firstParthOfSpeech = ""
    private var secondParthOfSpeech = ""
    private var thirdParthOfSpeech = ""
    private var parthOfSpeechs = [String]()
    private var definitions = [String]()
    private var examples = [String]()
    private var originalDetailEntity = [DetailModel]()
    private var tmpDetailEntity = [DetailModel]()
    private var filteredDetailEntity = [DetailModel]()
    private var tmpSynonyms = [String]()

    init(view: DetailViewControllerProtocol, interactor: DetailInteractorProtocol, router: DetailRouterProtocol) {
        self.interactor = interactor
        self.router = router
        self.view = view
    }

}

// MARK: - Private Functions
extension DetailPresenter {

    fileprivate func setThreePartOfSpeech() {
        guard let meanings = word?.meanings else { return }
        for meaning in meanings {
            if firstParthOfSpeech == "" {
                firstParthOfSpeech = meaning.partOfSpeech ?? ""
            }
            else if secondParthOfSpeech == "" {
                secondParthOfSpeech = meaning.partOfSpeech ?? ""
            }
            else if thirdParthOfSpeech == "" {
                thirdParthOfSpeech = meaning.partOfSpeech ?? ""
            }
        }
        print("First: \(firstParthOfSpeech), Second: \(secondParthOfSpeech), Third: \(thirdParthOfSpeech)")
    }

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

    fileprivate func setDefinitions() {
        definitions = allNounsDefinitions + allVerbsDefinitions + allAdjectivesDefinitions
    }

    fileprivate func setExamples() {
        examples = allNounsExamples + allVerbsExamples + allAdjectivesExamples
    }

    fileprivate func appendWordTypes() {
        for _ in 0..<allNounsDefinitions.count {
            parthOfSpeechs.append("Noun")
        }
        for _ in 0..<allVerbsDefinitions.count {
            parthOfSpeechs.append("Verb")
        }
        for _ in 0..<allAdjectivesDefinitions.count {
            parthOfSpeechs.append("Adjective")
        }
    }

    fileprivate func setDetailEntity() {
        setDefinitions()
        setExamples()
        for i in 0..<definitions.count {
            let entity = DetailModel(partOfSpeech: parthOfSpeechs[i], definitions: definitions[i], examples: examples[i])
            originalDetailEntity.append(entity)
        }
        tmpDetailEntity = originalDetailEntity
    }

//MARK: - Fetch Functions
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

// MARK: - DetailPresenterProtocol
extension DetailPresenter: DetailPresenterProtocol {

    func synonmButtonClick(word: String) {
        fetchWord(word: word)
    }

    func playSound() {
        let audios = word?.phonetics?.prefix(15).map { $0.audio }
        guard let audios else { return }

        var realAudio: String?
        for audio in audios {
            guard let audio else { return }
            if audio.suffix(4) == ".mp3" {
                audio != "" ? realAudio = audio: nil
            }
        }

        if realAudio != "" && realAudio != nil {
            interactor.playSound(realAudio!)
        } else {
            view.hideSoundButton()
            print("No audio available")
        }
        view.resetSoundImageTintColor()
    }

    func filtering(_ type: String) {
        title = title.filter { !$0.isWhitespace }
        filteredDetailEntity = getDetailEntity()
        if title == "Noun" {
            filteredDetailEntity = originalDetailEntity.filter { $0.partOfSpeech == "Noun" }
        }
        else if title == "Verb" {
            filteredDetailEntity = originalDetailEntity.filter { $0.partOfSpeech == "Verb" }
        }
        else if title == "Adjective" {
            filteredDetailEntity = originalDetailEntity.filter { $0.partOfSpeech == "Adjective" }
        }
        else if title.split(separator: ",").contains("Noun") && title.split(separator: ",").contains("Verb") && title.split(separator: ",").contains("Adjective") {
            filteredDetailEntity = originalDetailEntity
        }
        else if title.split(separator: ",").contains("Noun") && title.split(separator: ",").contains("Verb") {
            filteredDetailEntity = originalDetailEntity.filter { $0.partOfSpeech == "Noun" || $0.partOfSpeech == "Verb" }
        }
        else if title.split(separator: ",").contains("Noun") && title.split(separator: ",").contains("Adjective") {
            filteredDetailEntity = originalDetailEntity.filter { $0.partOfSpeech == "Noun" || $0.partOfSpeech == "Adjective" }
        }
        else if title.split(separator: ",").contains("Verb") && title.split(separator: ",").contains("Adjective") {
            filteredDetailEntity = originalDetailEntity.filter { $0.partOfSpeech == "Verb" || $0.partOfSpeech == "Adjective" }
        }

        tmpDetailEntity.removeAll()
        tmpDetailEntity = filteredDetailEntity
        view.updateView()
    }

//MARK: Setters
    // Set all types of the word. First called.
    func setAllTypesOfWord() {
        setThreePartOfSpeech()
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

    func resetFirstClicked() {
        isFirstClicked = false
    }

    func clearTitle() {
        title = ""
    }

//MARK: - Getters
    func getSynonyms() -> [String] {
        tmpSynonyms = self.synonyms?.prefix(5).map { $0.word } as! [String]
        return tmpSynonyms
    }

    var numberOfItems: Int {
        tmpDetailEntity.count
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

    func getMainButtonTitle() -> String {
        title
    }

    var clickedButtons: [String] {
        buttonArray
    }

    func getCancelBtnStatus() -> Bool {
        isCancelBtnClicked
    }

    func getDetailEntity() -> [DetailModel] {
        tmpDetailEntity
    }

//MARK: - Button Clicked Functions
    func cancelBtnClicked() {
        view.hideCancelButton()
        buttonArray.removeAll()
        isCancelBtnClicked = true
        isNounBtnClicked = false
        isVerbBtnClicked = false
        isAdjectiveBtnClicked = false
        view.cancelButtonClicked()
        tmpDetailEntity = originalDetailEntity
        view.updateView()
    }

    func nounButtonClicked() {
        view.showCancelButton()
        removeFromClickedButtons("Noun")
        if isFirstClicked { title += ", Noun" } else { title += "Noun"; isFirstClicked = true }
        buttonArray.append("Noun")
        view.hideSelectedButton()
        filtering(title)
    }

    func verbButtonClicked() {
        view.showCancelButton()
        removeFromClickedButtons("Verb")
        if isFirstClicked { title += ", Verb" } else { title += "Verb"; isFirstClicked = true }
        buttonArray.append("Verb")
        view.hideSelectedButton()
        filtering(title)
    }

    func adjectiveButtonClicked() {
        view.showCancelButton()
        removeFromClickedButtons("Adjective")
        if isFirstClicked { title += ", Adjective" } else { title += "Adjective"; isFirstClicked = true }
        buttonArray.append("Adjective")
        view.hideSelectedButton()
        filtering(title)
    }
}

extension DetailPresenter: DetailInteractorOutputProtocol {

}
