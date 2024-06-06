//
//  Alert.swift
//  Dictionary
//
//  Created by Melik Demiray on 6.06.2024.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alert.addAction($0) }
        present(alert, animated: true, completion: nil)
    }
}
