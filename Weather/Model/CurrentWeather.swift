//
//  CurrentWeather.swift
//  Weather
//
//  Created by Panuku Goutham on 22/05/21.
//

struct CurrentWeather: Codable {
    let code: Int
    let weather: [WeatherDetails]
    let main: Main
    let visibility: Int
    let wind: Wind
    let dt: Int
    let sys: Sys
    let timezone: Int
    
    enum CodingKeys: String, CodingKey {
        case code = "cod"
        case weather = "weather"
        case main = "main"
        case visibility = "visibility"
        case wind = "wind"
        case dt = "dt"
        case sys = "sys"
        case timezone = "timezone"
    }

}
