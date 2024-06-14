//
//  MockHomeRouter.swift
//  DictionaryTests
//
//  Created by Melik Demiray on 14.06.2024.
//

import Foundation
@testable import Dictionary

final class MockHomeRouter: HomeRouterProtocol {

    var invokedNavigateToWordDetail = false
    var invokedNavigateToWordDetailCount = 0
    var invokedNavigateToWordDetailParameters: (route: HomeRoutes, Void)?
    var word = Word(word: "test", phonetic: "test", phonetics: [Phonetic(text: "test", audio: "test", sourceURL: "test", license: License(name: "test", url: "test"))], meanings: [Meaning(partOfSpeech: "test", definitions: [Definition(definition: "test", synonyms: ["test"], antonyms: ["test"], example: "test")], synonyms: ["test"], antonyms: ["test"])], license: License(name: "test", url: "test"), sourceUrls: ["test"])
    var synonyms: SynoymModel?

    func navigateToWordDetail(_ route: HomeRoutes) {
       /* switch route {
        case .detail(word: word, synonyms: synonyms):
            invokedNavigateToWordDetail = true
            invokedNavigateToWordDetailCount += 1
            invokedNavigateToWordDetailParameters = (route, ())
            return
        }*/
    }

}
