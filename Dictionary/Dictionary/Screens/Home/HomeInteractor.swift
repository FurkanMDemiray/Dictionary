//
//  HomeInteractor.swift
//  Dictionary
//
//  Created by Melik Demiray on 5.06.2024.
//

import Foundation

protocol HomeInteractorProtocol {
    func fetchWord(word: String, completion: @escaping (Result<Word, Error>) -> Void)
}

protocol HomeInteractorOutputProtocol {

}

final class HomeInteractor {

    private let service: NetworkServiceProtocol
    var presenter: HomeInteractorOutputProtocol!
    var output: HomeInteractorOutputProtocol!

    init(service: NetworkServiceProtocol) {
        self.service = service
    }

}

extension HomeInteractor: HomeInteractorProtocol {

    func fetchWord(word: String, completion: @escaping (Result<Word, Error>) -> Void) {
        service.fetch(url: "https://api.dictionaryapi.dev/api/v2/entries/en/\(word)") { [weak self] (result: Result<[Word], Error>) in
            guard let self else { return }
            switch result {
            case .success(let words):
                if let word = words.first {
                    completion(.success(word))
                } else {
                    completion(.failure(NSError(domain: "No word found", code: 404, userInfo: nil)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}

extension HomeInteractor: HomeInteractorOutputProtocol {

}
