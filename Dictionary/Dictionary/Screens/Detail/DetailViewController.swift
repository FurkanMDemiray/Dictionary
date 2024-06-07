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
    func hideCancelButton()
    func showCancelButton()
    func cancelButtonClicked()
    func hideSelectedButton()
    func showAllButtons()
}

final class DetailViewController: UIViewController {

    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var phoneticLabel: UILabel!
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var nounButton: UIButton!
    @IBOutlet weak var verbButton: UIButton!
    @IBOutlet weak var adjectiveButton: UIButton!

    var presenter: DetailPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureButtons()
        setLabels()
    }

//MARK: - Configures
    private func configureButtons() {
        DispatchQueue.main.async {
            for button in [self.nounButton, self.verbButton, self.adjectiveButton, self.cancelButton, self.mainButton] {
                button?.layer.borderWidth = 1
                button?.layer.cornerRadius = 17.5
                button?.clipsToBounds = true
                button?.backgroundColor = .white
                button?.tintColor = .black
                button?.layer.borderColor = UIColor.darkGray.cgColor
            }
            self.mainButton.isHidden = true
            self.hideCancelButton()
        }
    }

    private func setLabels() {
        DispatchQueue.main.async {
            self.wordLabel.text = self.presenter.getWordName().capitalized
            self.phoneticLabel.text = self.presenter.getWordPhonetic()
        }
    }

//MARK: - Actions
    @IBAction func cancelBtnClicked(_ sender: Any) {
        presenter.cancelBtnClicked()
    }

    @IBAction func nounButtonClicked(_ sender: Any) {
        presenter.nounButtonClicked()
    }

    @IBAction func verbButtonClicked(_ sender: Any) {
        presenter.verbButtonClicked()
    }

    @IBAction func adjectiveButtonClicked(_ sender: Any) {
        presenter.adjectiveButtonClicked()
    }
}

//MARK: - DetailViewControllerProtocol
extension DetailViewController: DetailViewControllerProtocol {
    func hideSelectedButton() {
        DispatchQueue.main.async {
            for button in self.presenter.clickedButtons {
                if button == "Noun" {
                    self.nounButton.isHidden = true
                }
                else if button == "Verb" {
                    self.verbButton.isHidden = true
                }
                else if button == "Adjective" {
                    self.adjectiveButton.isHidden = true
                }
            }
            self.mainButton.isHidden = false
            self.mainButton.layer.borderColor = UIColor.systemBlue.cgColor
            self.mainButton.setTitle(self.presenter.getMainButtonTitle(), for: .normal)
        }
    }

    func showAllButtons() {
        DispatchQueue.main.async {
            for button in [self.nounButton, self.verbButton, self.adjectiveButton] {
                button?.isHidden = false
            }
        }
    }

    func cancelButtonClicked() {
        DispatchQueue.main.async {
            self.presenter.clearTitle()
            self.mainButton.isHidden = true
            self.showAllButtons()
            self.presenter.resetFirstClicked()
        }
    }

    func hideCancelButton() {
        cancelButton.isHidden = true
    }

    func showCancelButton() {
        cancelButton.isHidden = false
    }

    func updateView() {

    }

    func showError(error: Error) {

    }
}
