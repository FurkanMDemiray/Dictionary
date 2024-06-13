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
    var firstButtoName: String { get }
    var secondButtoName: String { get }
    var thirdButtoName: String { get }

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
        let names = [firstParthOfSpeech, secondParthOfSpeech, thirdParthOfSpeech]
        view.setButtonNames(names: names)
    }

    fileprivate func addToClickedButtons(_ buttons: String) {
        if buttons == firstParthOfSpeech {
            buttonArray.append(firstParthOfSpeech)
        }
        else if buttons == secondParthOfSpeech {
            buttonArray.append(secondParthOfSpeech)
        }
        else if buttons == thirdParthOfSpeech {
            buttonArray.append(thirdParthOfSpeech)
        }
    }

    fileprivate func removeFromClickedButtons(_ buttons: String) {
        if buttons == firstParthOfSpeech {
            buttonArray.removeAll { $0 == firstParthOfSpeech }
        }
        else if buttons == secondParthOfSpeech {
            buttonArray.removeAll { $0 == secondParthOfSpeech }
        }
        else if buttons == thirdParthOfSpeech {
            buttonArray.removeAll { $0 == thirdParthOfSpeech }
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
            parthOfSpeechs.append(firstParthOfSpeech)
        }
        for _ in 0..<allVerbsDefinitions.count {
            parthOfSpeechs.append(secondParthOfSpeech)
        }
        for _ in 0..<allAdjectivesDefinitions.count {
            parthOfSpeechs.append(thirdParthOfSpeech)
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

    var firstButtoName: String {
        firstParthOfSpeech
    }

    var secondButtoName: String {
        secondParthOfSpeech
    }

    var thirdButtoName: String {
        thirdParthOfSpeech
    }


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
        if title == firstParthOfSpeech {
            filteredDetailEntity = originalDetailEntity.filter { $0.partOfSpeech == firstParthOfSpeech }
        }
        else if title == secondParthOfSpeech {
            filteredDetailEntity = originalDetailEntity.filter { $0.partOfSpeech == secondParthOfSpeech }
        }
        else if title == thirdParthOfSpeech {
            filteredDetailEntity = originalDetailEntity.filter { $0.partOfSpeech == thirdParthOfSpeech }
        }
        else if title.split(separator: ",").contains("\(firstParthOfSpeech)") && title.split(separator: ",").contains("\(secondParthOfSpeech)") && title.split(separator: ",").contains("\(thirdParthOfSpeech)") {
            filteredDetailEntity = originalDetailEntity
        }
        else if title.split(separator: ",").contains("\(firstParthOfSpeech)") && title.split(separator: ",").contains("\(secondParthOfSpeech)") {
            filteredDetailEntity = originalDetailEntity.filter { $0.partOfSpeech == "\(firstParthOfSpeech)" || $0.partOfSpeech == "\(secondParthOfSpeech)" }
        }
        else if title.split(separator: ",").contains("\(firstParthOfSpeech)") && title.split(separator: ",").contains("\(thirdParthOfSpeech)") {
            filteredDetailEntity = originalDetailEntity.filter { $0.partOfSpeech == "\(firstParthOfSpeech)" || $0.partOfSpeech == "\(thirdParthOfSpeech)" }
        }
        else if title.split(separator: ",").contains("\(secondParthOfSpeech)") && title.split(separator: ",").contains("\(thirdParthOfSpeech)") {
            filteredDetailEntity = originalDetailEntity.filter { $0.partOfSpeech == "\(secondParthOfSpeech)" || $0.partOfSpeech == "\(thirdParthOfSpeech)" }
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
            if meaning.partOfSpeech == firstParthOfSpeech {
                for definition in definitions {
                    allNounsDefinitions.append(definition.definition ?? "")
                }
                for example in definitions {
                    allNounsExamples.append(example.example ?? "")
                }
            }
            else if meaning.partOfSpeech == secondParthOfSpeech {
                for definition in definitions {
                    allVerbsDefinitions.append(definition.definition ?? "")
                }
                for example in definitions {
                    allVerbsExamples.append(example.example ?? "")
                }
            }
            else if meaning.partOfSpeech == thirdParthOfSpeech {
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
        removeFromClickedButtons(firstParthOfSpeech)
        if isFirstClicked { title += ", \(firstParthOfSpeech)" } else { title += firstParthOfSpeech; isFirstClicked = true }
        buttonArray.append(firstParthOfSpeech)
        view.hideSelectedButton()
        filtering(title)
    }

    func verbButtonClicked() {
        view.showCancelButton()
        removeFromClickedButtons(secondParthOfSpeech)
        if isFirstClicked { title += ", \(secondParthOfSpeech)" } else { title += secondParthOfSpeech; isFirstClicked = true }
        buttonArray.append(secondParthOfSpeech)
        view.hideSelectedButton()
        filtering(title)
    }

    func adjectiveButtonClicked() {
        view.showCancelButton()
        removeFromClickedButtons(thirdParthOfSpeech)
        if isFirstClicked { title += ", \(thirdParthOfSpeech)" } else { title += thirdParthOfSpeech; isFirstClicked = true }
        buttonArray.append(thirdParthOfSpeech)
        view.hideSelectedButton()
        filtering(title)
    }
}

extension DetailPresenter: DetailInteractorOutputProtocol {

}
