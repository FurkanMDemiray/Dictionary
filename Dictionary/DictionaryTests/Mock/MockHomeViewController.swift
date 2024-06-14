//
//  MockHomeViewController.swift
//  DictionaryTests
//
//  Created by Melik Demiray on 14.06.2024.
//

import Foundation
@testable import Dictionary

final class MockHomeViewController: HomeViewControllerProtocol {

    var isUpdateViewCalled = false
    var isShowErrorCalled = false
    var isAdjustSearchButtonCalled = false

    var updateViewCount = 0
    var showErrorCount = 0
    var adjustSearchButtonCount = 0

    var invokedAdjustSearchButton: (height: CGFloat, Void)?

    func reloadTableView() {
        isUpdateViewCalled = true
        updateViewCount += 1
    }
    
    func showError(error: any Error) {
        isShowErrorCalled = true
        showErrorCount += 1
    }
    
    func adjustSearchButton(forKeyboardHeight height: CGFloat) {
        isAdjustSearchButtonCalled = true
        adjustSearchButtonCount += 1
        invokedAdjustSearchButton = (height, ())    
    }

}
