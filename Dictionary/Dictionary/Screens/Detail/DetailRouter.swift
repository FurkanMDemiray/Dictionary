//
//  DetailRouter.swift
//  Dictionary
//
//  Created by Melik Demiray on 6.06.2024.
//

import Foundation
import UIKit

enum DetailRoutes {
    case detail(word: Word?, synonyms: [SynoymModel]?)
}

protocol DetailRouterProtocol {
    func navigateToWordDetail(_ route: HomeRoutes)
}

final class DetailRouter {

    weak var viewController: DetailViewController?

    static func createDetailModule(word: Word, synonyms: [SynoymModel]) -> DetailViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let view = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {
            fatalError("Failed to instantiate DetailViewController from storyboard.")
        }
        let router = DetailRouter()
        let interactor = DetailInteractor(service: NetworkService())
        let presenter = DetailPresenter(view: view, interactor: interactor, router: router)

        view.presenter = presenter
        interactor.output = presenter
        router.viewController = view
        presenter.word = word
        presenter.synonyms = synonyms

        return view
    }

}

extension DetailRouter: DetailRouterProtocol {
    func navigateToWordDetail(_ route: HomeRoutes) {
        switch route {
        case .detail(let word, let synonyms):
            guard let word else { return }
            guard let synonyms else { return }
            let detailViewController = DetailRouter.createDetailModule(word: word, synonyms: synonyms)
            viewController?.navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}
