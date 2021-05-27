//
//  Constants.swift
//  Weather
//
//  Created by Panuku Goutham on 22/05/21.
//

import Foundation

class Constants {
    static let todayForecastApi        =   "http://api.openweathermap.org/data/2.5/weather?"
    static let fiveDaysForecastApi     =   "http://api.openweathermap.org/data/2.5/forecast?"
    static let appId                   =   "fae7190d7e6433ec3a45285ffcf55c86"
    static let savedLocations          =   "SavedLocations"
    static let tempUnits               =   "UnitsSelected"
    static let metric                  =   "metric"
    static let imperial                =   "imperial"
}

enum ViewControllerIdentifier: String {
    case MapViewController, CityWeatherViewController, SettingsViewController, HelpViewController
}

enum CellIdentifier: String {
    case DefaultCell, CityCell, WeatherDetailsCell, TempCell, WeatherDetailsCollectionViewCell, SettingsCell
}

extension Notification.Name {
    static let didUpdateCitiesData = Notification.Name("didUpdateCitiesData")
    static let didUpdateSettingTable = Notification.Name("didUpdateSettingTable")
}
