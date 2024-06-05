//
//  HomeRouter.swift
//  Dictionary
//
//  Created by Melik Demiray on 5.06.2024.
//

import Foundation

protocol HomeRouterProtocol {
    func navigateToWordDetail(word: Word)
}

final class HomeRouter: HomeRouterProtocol {
    
    private weak var viewController: HomeViewController?
    
    init(viewController: HomeViewController) {
        self.viewController = viewController
    }
    
    func navigateToWordDetail(word: Word) {
        //let wordDetailViewController = WordDetailBuilder.make(word: word)
        //viewController?.navigationController?.pushViewController(wordDetailViewController, animated: true)
    }
    
}
