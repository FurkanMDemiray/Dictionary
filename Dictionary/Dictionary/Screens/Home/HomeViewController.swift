//
//  ViewController.swift
//  Dictionary
//
//  Created by Melik Demiray on 5.06.2024.
//

import UIKit

protocol HomeViewControllerProtocol: AnyObject {
    func updateView()
    func showError(error: Error)
    func adjustSearchButton(forKeyboardHeight height: CGFloat)
}

final class HomeViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchButtonBottomConstraint: NSLayoutConstraint!

    var presenter: HomePresenterProtocol!

    override func viewWillAppear(_ animated: Bool) {
        DetailCell.counter = 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        setupFeatures()

    }

    deinit {
        removeKeyboardObservers()
    }

//MARK: - Configure functions
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = false
        tableView.register(UINib(nibName: "RecentCell", bundle: nil), forCellReuseIdentifier: "RecentCell")
    }

    private func configureSearchBar() {
        searchBar.backgroundColor = .white
        searchBar.backgroundImage = UIImage()
    }

    private func configureTitle() {
        let titleLabel = UILabel()
        titleLabel.text = "VIPER Dictionary"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel
    }

    private func setupFeatures() {
        configureTitle()
        configureTableView()
        configureSearchBar()
        setupKeyboardObservers()
        hideKeyboardWhenTappedAround()
    }

//MARK: - Keyboard Observers
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

//MARK: - Actions
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            presenter.keyboardWillShow(withHeight: keyboardHeight)
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        presenter.keyboardWillHide()
    }

    @IBAction func searchBtnClicked(_ sender: Any) {
        guard let word = searchBar.text else { return }
        if word.isEmpty {
            showAlert(title: "Error", message: "Please enter a word", actions: [UIAlertAction(title: "OK", style: .default, handler: nil)])
            return
        }
        presenter.searchButtonTapped(word: word)
        presenter.saveRecentWord(word: word)
    }
}

// MARK: - HomeViewControllerProtocol
extension HomeViewController: HomeViewControllerProtocol {

    func updateView() {
        tableView.reloadData()
    }

    func showError(error: Error) {
        showAlert(title: "Error", message: error.localizedDescription, actions: [UIAlertAction(title: "OK", style: .default, handler: nil)])
    }

    func adjustSearchButton(forKeyboardHeight height: CGFloat) {
        searchButtonBottomConstraint.constant = height + 8
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - UISearchBarDelegate
extension HomeViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Implement search logic if needed
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRecentWords
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentCell", for: indexPath) as! RecentCell
        cell.configure(with: presenter.recentWord(at: indexPath.row))
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let word = presenter.recentWord(at: indexPath.row)
        searchBar.text = word
        presenter.searchButtonTapped(word: word)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            showAlert(
                title: "Are you sure?",
                message: "Do you want to delete this word?",
                actions: [UIAlertAction(
                    title: "Cancel",
                    style: .cancel,
                    handler: nil
                    ),
                    UIAlertAction(
                        title: "Delete",
                        style: .destructive
                    ) { _ in self.presenter.deleteRecentWord(
                        at: indexPath.row
                        )
                    }]
            )
        }
    }
}

