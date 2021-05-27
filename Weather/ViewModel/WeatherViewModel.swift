//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Panuku Goutham on 22/05/21.
//

import Foundation

class WeatherViewModel {
    
    private var location : LocationDetails?
    private var apiManager : APIManager?
    private(set) var currentWeather : CurrentWeather? {
        didSet {
            self.updateProperties()
            self.bindWeatherViewModelToController()
        }
    }
    
    var bindWeatherViewModelToController : (() -> ()) = {}
    var errorHandling : ((String?) -> Void)?

    private(set) var currentTempString = ""
    private(set) var weatherString = ""
    private(set) var highTempString = ""
    private(set) var lowTempString = ""
    private(set) var highLowTempString = ""
    private(set) var dayString = ""
    private(set) var feelsLikeString = ""
    private(set) var humidityString = ""
    private(set) var pressureString = ""
    private(set) var visibilityString = ""
    private(set) var windString = ""
    private(set) var sunriseString = ""
    private(set) var sunsetString = ""
    private(set) var weatherDetailsArray = Array<Any>()

    init(location: LocationDetails?) {
        self.location = location
        self.apiManager =  APIManager()
    }
    
    func getWeather(apiType: APIType) {
        getWeatherFromAPIManager(apiType: apiType)
    }

    private func updateProperties() {
        guard let currentWeather = self.currentWeather else { return }
        let tempUnits = UserDefaults.standard.value(forKey: Constants.tempUnits) as? String ?? Constants.metric
        let tempSymbol = (tempUnits == Constants.metric) ? "°C" : "°F"
        currentTempString = "\(String(describing: Int(currentWeather.main.temp)))\(tempSymbol)"
        weatherString = String(describing: currentWeather.weather[0].main)
        highTempString = String(describing: Int(currentWeather.main.tempMax))
        lowTempString = String(describing: Int(currentWeather.main.tempMin))
        highLowTempString = String(describing: "H:\(highTempString)\(tempSymbol)  L:\(lowTempString)\(tempSymbol)")
        dayString = getDayStringFromTimeInterval(timeInterval: currentWeather.dt, dateFormat: "EEEE", timezone: currentWeather.timezone)
        
        sunriseString = getDayStringFromTimeInterval(timeInterval: currentWeather.sys.sunrise, dateFormat: "h:mm a", timezone: currentWeather.timezone)
        weatherDetailsArray.append(["desc": "Sunrise", "value": "\(sunriseString)"])

        sunsetString = getDayStringFromTimeInterval(timeInterval: currentWeather.sys.sunset, dateFormat: "h:mm a", timezone: currentWeather.timezone)
        weatherDetailsArray.append(["desc": "Sunset", "value": "\(sunsetString)"])
        
        humidityString = String(describing: "\(Int(currentWeather.main.humidity))%")
        weatherDetailsArray.append(["desc": "Humidity", "value": humidityString])
        
        windString = "\(currentWeather.wind.speed) km/h"
        weatherDetailsArray.append(["desc": "Wind", "value": windString])
        
        feelsLikeString = "\(Int(currentWeather.main.feelsLike))\(tempSymbol)"
        weatherDetailsArray.append(["desc": "Feels Like", "value": feelsLikeString])
        
        pressureString = "\(Int(currentWeather.main.pressure)) hPa"
        weatherDetailsArray.append(["desc": "Pressure", "value": "\(pressureString)"])

        visibilityString = "\(Int(currentWeather.visibility)/1000) km"
        weatherDetailsArray.append(["desc": "Visibility", "value": "\(visibilityString)"])
    }
}


extension WeatherViewModel {
    
    private func getWeatherFromAPIManager(apiType: APIType) {
        guard let latitude = location?.latitude else { return }
        guard let longitude = location?.longitude else { return }
        self.apiManager?.getWeather(apiType: apiType, lat: latitude, long: longitude, completion: { (weather, error) in
            if let error = error {
                self.errorHandling?(error)
                return
            }
            guard let weather = weather  else { return }
            self.currentWeather = weather
            print("Current Weather Object:", weather)
        })
    }
    
    private func getDayStringFromTimeInterval(timeInterval: Int, dateFormat: String, timezone: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timeInterval))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone(secondsFromGMT: timezone)
        let dayString = dateFormatter.string(from: date)
        return dayString
    }
    
}
