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

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        configureTableView()
        setupKeyboardObservers()
        hideKeyboardWhenTappedAround()
    }

    deinit {
        removeKeyboardObservers()
    }

    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UINib(nibName: "RecentCell", bundle: nil), forCellReuseIdentifier: "RecentCell")
    }

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
        presenter.searchButtonTapped(word: word)
    }
}

// MARK: - HomeViewControllerProtocol
extension HomeViewController: HomeViewControllerProtocol {

    func updateView() {
        //tableView.reloadData()
    }

    func showError(error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
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
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentCell", for: indexPath)
        return cell
    }
}

