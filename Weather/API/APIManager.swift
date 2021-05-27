//
//  APIManager.swift
//  Weather
//
//  Created by Panuku Goutham on 22/05/21.
//

import Foundation

enum APIType {
    case todayForecast
    case fiveDaysForecast
}

class APIManager {
    func getWeather(apiType: APIType, lat: Double, long: Double, completion: @escaping (_ weather: CurrentWeather?, _ error: String?) -> ()) {
        let tempUnits = UserDefaults.standard.value(forKey: Constants.tempUnits) as? String ?? Constants.metric
        var weatherDataURL = ""
        switch apiType {
        case .todayForecast:
            weatherDataURL = Constants.todayForecastApi+"lat=\(lat)&lon=\(long)&appid=\(Constants.appId)&units=\(tempUnits)"
        case .fiveDaysForecast:
            weatherDataURL = Constants.fiveDaysForecastApi+"lat=\(lat)&lon=\(long)&appid=\(Constants.appId)&units=\(tempUnits)"
        }
        print(weatherDataURL)
        weatherApiCall(urlString: weatherDataURL) { (data, error) in
            guard let data = data, error == nil else {
                print("Failed to get data")
                return completion(nil, error)
            }
            self.createWeatherObjectWith(json: data, completion: { (weather, error) in
                if let error = error {
                    print("Failed to convert data")
                    return completion(nil, error)
                }
                return completion(weather, nil)
            })
        }
    }

}

extension APIManager {
    private func weatherApiCall(urlString: String, completion: @escaping (_ data: Data?, _ error: String?) -> Void) {
        guard let url = URL(string: urlString) else {
            return completion(nil, "Invalid Url")
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            guard error == nil else {
                print("Error calling api")
                return completion(nil, "Unable to get weather details")
            }
            guard let responseData = data else {
                print("Data is nil")
                return completion(nil, "Unable to get weather details")
            }
            completion(responseData, nil)
        }
        task.resume()
    }

    private func createWeatherObjectWith(json: Data, completion: @escaping (_ data: CurrentWeather?, _ error: String?) -> Void) {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let weather = try decoder.decode(CurrentWeather.self, from: json)
            return completion(weather, nil)
        } catch let error {
            print("Error creating current weather from JSON because: \(error.localizedDescription)")
            return completion(nil, "Unable to get weather details")
        }
    }
}
