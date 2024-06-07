//
//  DetailRouter.swift
//  Dictionary
//
//  Created by Melik Demiray on 6.06.2024.
//

import Foundation
import UIKit

protocol DetailRouterProtocol {

}

final class DetailRouter {

    weak var viewController: DetailViewController?

    static func createDetailModule(_ word: Word) -> DetailViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let view = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {
            fatalError("Failed to instantiate DetailViewController from storyboard.")
        }
        let router = DetailRouter()
        let interactor = DetailInteractor()
        let presenter = DetailPresenter(view: view, interactor: interactor, router: router)

        view.presenter = presenter
        interactor.output = presenter
        router.viewController = view
        presenter.word = word

        return view
    }

}

extension DetailRouter: DetailRouterProtocol {

}