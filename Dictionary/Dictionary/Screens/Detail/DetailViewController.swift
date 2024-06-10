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

    @IBOutlet private weak var wordLabel: UILabel!
    @IBOutlet private weak var phoneticLabel: UILabel!
    @IBOutlet private weak var mainButton: UIButton!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var nounButton: UIButton!
    @IBOutlet private weak var verbButton: UIButton!
    @IBOutlet private weak var adjectiveButton: UIButton!
    @IBOutlet private weak var volumeImage: UIImageView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var scrollViewHeightContraint: NSLayoutConstraint!

    var presenter: DetailPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConfigure()
    }

//MARK: - Configures
    private func configureButtons() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
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
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
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
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
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
    @IBAction private func cancelBtnClicked(_ sender: Any) {
        presenter.cancelBtnClicked()
    }

    @IBAction private func nounButtonClicked(_ sender: Any) {
        presenter.nounButtonClicked()
    }

    @IBAction private func verbButtonClicked(_ sender: Any) {
        presenter.verbButtonClicked()
    }

    @IBAction private func adjectiveButtonClicked(_ sender: Any) {
        presenter.adjectiveButtonClicked()
    }

    @objc private func volumeImageTapped() {
        presenter.playSound()
    }
}

//MARK: - DetailViewControllerProtocol
extension DetailViewController: DetailViewControllerProtocol {

    func hideSoundButton() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.volumeImage.isHidden = true
        }
    }

    func hideSelectedButton() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
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
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            for button in [self.nounButton, self.verbButton, self.adjectiveButton] {
                button?.isHidden = false
            }
        }
    }

    func cancelButtonClicked() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
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
        tableView.reloadData()
    }

    func showError(error: Error) {

    }
}


//MARK: - UITableViewDelegate, UITableViewDataSource
extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfItems
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! DetailCell
        cell.configureCell(presenter.getDetailEntity()[indexPath.row])
        return cell
    }
}
