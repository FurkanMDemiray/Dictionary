//
//  Entity.swift
//  Dictionary
//
//  Created by Melik Demiray on 5.06.2024.
//

import Foundation

// MARK: - Words
struct Word: Decodable {
    static func == (lhs: Word, rhs: Word) -> Bool {
        return lhs.word == rhs.word
    }

    let word, phonetic: String?
    let phonetics: [Phonetic]?
    let meanings: [Meaning]?
    let license: License?
    let sourceUrls: [String]?
}

// MARK: - License
struct License: Decodable {
    let name: String?
    let url: String?
}

// MARK: - Meaning
struct Meaning: Decodable {
    let partOfSpeech: String?
    let definitions: [Definition]?
    let synonyms, antonyms: [String]?
}

// MARK: - Definition
struct Definition: Decodable {
    let definition: String?
    let synonyms: [String]?
    let antonyms: [String]?
    let example: String?
}

// MARK: - Phonetic
struct Phonetic: Decodable {
    let text: String?
    let audio: String?
    let sourceURL: String?
    let license: License?

    enum CodingKeys: String, CodingKey {
        case text, audio
        case sourceURL = "sourceUrl"
        case license
    }
}
