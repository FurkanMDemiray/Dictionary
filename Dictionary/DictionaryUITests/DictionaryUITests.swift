//
//  DictionaryUITests.swift
//  DictionaryUITests
//
//  Created by Melik Demiray on 5.06.2024.
//

import XCTest

final class DictionaryUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExistenceOfTableView() {
        app.launch()
        XCTAssertTrue(app.isDisplayingTableView)
    }

    func testExistenceOfSearchBar() {
        app.launch()
        XCTAssertTrue(app.isDisplayingSearchBar)
    }

}

extension XCUIApplication {
    var tableView: XCUIElement! {
        tables["tableView"]
    }

    var serachBar: XCUIElement! {
        searchFields["searchBar"]
    }

    var isDisplayingTableView: Bool {
        tableView.exists
    }

    var isDisplayingSearchBar: Bool {
        searchFields.element.exists
    }
}
