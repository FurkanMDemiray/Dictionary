//
//  MockHomeInteractor.swift
//  DictionaryTests
//
//  Created by Melik Demiray on 14.06.2024.
//

import Foundation
@testable import Dictionary

final class MockHomeInteractor: HomeInteractorProtocol {

    var invokedFetchWord = false
    var invokedFetchWordCount = 0
    var invokedSynonyms = false
    var invokedSynonymsCount = 0

    func fetchWord(word: String, completion: @escaping (Result<Word, Error>) -> Void) {
        invokedFetchWord = true
        invokedFetchWordCount += 1
    }

    func fetchWordSynonyms(word: String, completion: @escaping (Result<[SynoymModel], Error>) -> Void) {
        invokedSynonyms = true
        invokedSynonymsCount += 1
    }


}
