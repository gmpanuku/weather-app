//
//  SavedLocationsViewModelTests.swift
//  WeatherTests
//
//  Created by Panuku Goutham on 25/05/21.
//

import XCTest
@testable import Weather

class SavedLocationsViewModelTests: XCTestCase {

    var savedLocationsViewModel : SavedLocationsViewModel!
    
    override func setUp() {
        savedLocationsViewModel = SavedLocationsViewModel()
    }
    
    override func tearDown() {
        savedLocationsViewModel = nil
    }

    func testGetSavedLocations() {
        let expectation = XCTestExpectation(description: "Got Saved Locations")
        self.savedLocationsViewModel.bindSavedLocationsViewModelToController = {
            expectation.fulfill()
        }
        self.savedLocationsViewModel.getSavedLocations()
        wait(for: [expectation], timeout: 5.0)

    }
    
    func testSaveLocation() {
        let location = LocationDetails(locationName: "Hyderabad", country: "India", latitude: 17.385044, longitude: 78.486671)
        let expectation = XCTestExpectation(description: "Location Saved")
        self.savedLocationsViewModel.bindSavedLocationsViewModelToController = {
            expectation.fulfill()
        }
        self.savedLocationsViewModel.saveLocation(location: location)
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testSaveAnotherLocation() {
        let location = LocationDetails(locationName: "Chennai", country: "India", latitude: 13.0827, longitude: 80.2707)
        let expectation = XCTestExpectation(description: "Location Saved")
        self.savedLocationsViewModel.bindSavedLocationsViewModelToController = {
            expectation.fulfill()
        }
        self.savedLocationsViewModel.saveLocation(location: location)
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testRemoveLocation() {
        let expectation = XCTestExpectation(description: "Location Deleted")
        self.savedLocationsViewModel.bindSavedLocationsViewModelToController = {
            expectation.fulfill()
        }
        self.savedLocationsViewModel.removeLocation(viewModel: self.savedLocationsViewModel, index: 0)
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testRemoveAllLocations() {
        let expectation = XCTestExpectation(description: "All Locations Deleted")
        let isDeleted = self.savedLocationsViewModel.removeAllLocations()
        if isDeleted {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
}
