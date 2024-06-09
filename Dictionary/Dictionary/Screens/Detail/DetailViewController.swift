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
    func hideSoundButton()
}

final class DetailViewController: UIViewController {

    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var phoneticLabel: UILabel!
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var nounButton: UIButton!
    @IBOutlet weak var verbButton: UIButton!
    @IBOutlet weak var adjectiveButton: UIButton!
    @IBOutlet weak var volumeImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollViewHeightContraint: NSLayoutConstraint!

    var presenter: DetailPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConfigure()
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

    private func configureVolumeImage() {
        volumeImage.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(volumeImageTapped))
        volumeImage.addGestureRecognizer(tap)
    }

    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "DetailCell", bundle: nil), forCellReuseIdentifier: "DetailCell")
    }

    private func configureConstraints() {
        DispatchQueue.main.async {
            self.tableViewHeightConstraint.constant = self.tableView.contentSize.height
            self.scrollViewHeightContraint.constant = self.tableView.contentSize.height
        }
    }

    private func setupConfigure() {
        configureButtons()
        setLabels()
        configureVolumeImage()
        presenter.getTypes()
        configureTableView()
        configureConstraints()
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

    @objc func volumeImageTapped() {
        presenter.playSound()
    }
}

//MARK: - DetailViewControllerProtocol
extension DetailViewController: DetailViewControllerProtocol {

    func hideSoundButton() {
        DispatchQueue.main.async {
            self.volumeImage.isHidden = true
        }
    }

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


//MARK: - UITableViewDelegate, UITableViewDataSource
extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.nouns.count + presenter.verbs.count + presenter.adjectives.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! DetailCell
        cell.configureCell(partOfSpeech: presenter.partsOfSpeech[indexPath.row], definition: presenter.definitions[indexPath.row])
        return cell
    }
}
