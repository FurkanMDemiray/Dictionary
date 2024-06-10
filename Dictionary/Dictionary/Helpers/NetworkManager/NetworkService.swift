//
//  NetworkService.swift
//  Dictionary
//
//  Created by Melik Demiray on 5.06.2024.
//

import Foundation
import Alamofire

protocol NetworkServiceProtocol {
    func fetch<T: Decodable>(url: String, completion: @escaping (Result<T, Error>) -> Void)
}

final class NetworkService: NetworkServiceProtocol {

    func fetch<T: Decodable>(url: String, completion: @escaping (Result<T, Error>) -> Void) {
        AF.request(url).responseDecodable(of: T.self) { [weak self] response in
            guard let self else { return }
            switch response.result {
            case .success(let value):
                completion(.success(value))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}
