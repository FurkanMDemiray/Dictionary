//
//  HomePresenterTests.swift
//  DictionaryTests
//
//  Created by Melik Demiray on 14.06.2024.
//

import XCTest
@testable import Dictionary

final class HomePresenterTests: XCTestCase {

    var presenter: HomePresenter!
    var interactor: MockHomeInteractor!
    var view: MockHomeViewController!
    var router: MockHomeRouter!

    override func setUp() {
        super.setUp()

        view = .init()
        interactor = .init()
        router = .init()
        presenter = .init(view: view, router: router, interactor: interactor)
    }

    override func tearDown() {
        super.tearDown()

        view = nil
        interactor = nil
        router = nil
        presenter = nil
    }

    func testViewDidLoadInvokesRequiredViewMethods() {
        XCTAssertFalse(view.isUpdateViewCalled)
        presenter.viewDidLoad()
        XCTAssertTrue(view.isUpdateViewCalled)
    }

    func testSearchButtonTappedInvokesFetchWord() {
        let word = "test"
        XCTAssertFalse(interactor.invokedFetchWord)
        presenter.searchButtonTapped(word: word)
        XCTAssertTrue(interactor.invokedFetchWord)
    }

    func testKeyboardWillShowInvokesAdjustSearchButton() {
        let height: CGFloat = 100
        XCTAssertFalse(view.isAdjustSearchButtonCalled)
        presenter.keyboardWillShow(withHeight: height)
        XCTAssertTrue(view.isAdjustSearchButtonCalled)
    }

    func testKeyboardWillHideInvokesAdjustSearchButton() {
        XCTAssertFalse(view.isAdjustSearchButtonCalled)
        presenter.keyboardWillHide()
        XCTAssertTrue(view.isAdjustSearchButtonCalled)
    }

    func testSaveRecentWordInvokesGetRecentWords() {
        XCTAssertFalse(presenter.getRecentWords().isEmpty)
        presenter.saveRecentWord(word: "test")
        XCTAssertFalse(presenter.getRecentWords().isEmpty)
    }

    func testGetRecentWordsReturnsNonEmptyArray() {
        presenter.saveRecentWord(word: "test")
        XCTAssertFalse(presenter.getRecentWords().isEmpty)
    }

}
