//
//  HomeRouter.swift
//  Dictionary
//
//  Created by Melik Demiray on 5.06.2024.
//

import Foundation
import UIKit

enum HomeRoutes {
    case detail(word: Word?, synonyms: [SynoymModel]?)
}

protocol HomeRouterProtocol {
    func navigateToWordDetail(_ route: HomeRoutes)
}

final class HomeRouter {

    weak var viewController: HomeViewController?

    static func createModule() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let view = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else {
            fatalError("Failed to instantiate HomeViewController from storyboard.")
        }

        let router = HomeRouter()
        let interactor = HomeInteractor(service: NetworkService())
        let presenter = HomePresenter(view: view, router: router, interactor: interactor)

        view.presenter = presenter
        interactor.output = presenter
        router.viewController = view

        return view
    }
}

extension HomeRouter: HomeRouterProtocol {
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
