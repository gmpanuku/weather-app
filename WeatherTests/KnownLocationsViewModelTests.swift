//
//  KnownLocationsViewModelTests.swift
//  WeatherTests
//
//  Created by Panuku Goutham on 25/05/21.
//

import XCTest
@testable import Weather

class KnownLocationsViewModelTests: XCTestCase {

    var viewModel : KnownLocationsViewModel!
    
    override func setUp() {
        viewModel = KnownLocationsViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
    }
    
    func testGetKnownLocationsWithInvalidFile() {
        self.viewModel.getKnownLocations(fileName: "test", ext: "json")
        XCTAssertNil(self.viewModel.locationsArray, "Expected locationsArray nil")
    }

    func testGetKnownLocations() {
        let expectation = XCTestExpectation(description: "Got Data From File")
        self.viewModel.getKnownLocations(fileName: "Locations", ext: "json")
        guard let count = self.viewModel.locationsArray?.count else {
            XCTAssert(false, "Can't get data from Locations.json")
            return
        }
        if count > 0 {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
    

}
