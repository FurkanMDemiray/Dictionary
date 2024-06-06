//
//  DetailViewController.swift
//  Dictionary
//
//  Created by Melik Demiray on 6.06.2024.
//

import UIKit

protocol DetailViewControllerProtocol: AnyObject {
    func updateView()
    func showError(error: Error)
}

final class DetailViewController: UIViewController {

    var presenter: DetailPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

extension DetailViewController: DetailViewControllerProtocol {
    func updateView() {

    }

    func showError(error: Error) {

    }
}
