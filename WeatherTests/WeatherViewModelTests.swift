//
//  WeatherTests.swift
//  WeatherTests
//
//  Created by Panuku Goutham on 24/05/21.
//

import XCTest
@testable import Weather

class WeatherViewModelTests: XCTestCase {
    var location: LocationDetails!
    var weatherViewModel : WeatherViewModel!

    override func setUp() {
        super.setUp()
        self.location = LocationDetails(locationName: "Visakhapatnam", country: "India", latitude: 17.6868, longitude: 83.2185)
        self.weatherViewModel = WeatherViewModel(location: location)
    }
    
    override func tearDown() {
        self.location = nil
        self.weatherViewModel = nil
        super.tearDown()
    }
    
    func testGetWeather() {
        let expectation = XCTestExpectation(description: "Got Weather Details")
        self.weatherViewModel.bindWeatherViewModelToController = {
            expectation.fulfill()
        }
        self.weatherViewModel.getWeather(apiType: APIType.todayForecast)
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testGetFivedaysWeather() {
        self.weatherViewModel.getWeather(apiType: APIType.fiveDaysForecast)
        XCTAssertNil(self.weatherViewModel.currentWeather, "Expected currentWeather nil")
    }
    
    func testGetTodayWeatherWithNoLocation() {
        self.weatherViewModel = WeatherViewModel(location: nil)
        XCTAssertNil(self.weatherViewModel.currentWeather, "Expected currentWeather nil")
    }

}
