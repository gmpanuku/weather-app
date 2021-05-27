//
//  Main.swift
//  Weather
//
//  Created by Panuku Goutham on 22/05/21.
//

struct Main: Codable {
    let temp: Double
    let feelsLike: Double
    let pressure: Double
    let humidity: Double
    let tempMin: Double
    let tempMax: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike
        case pressure
        case humidity
        case tempMin
        case tempMax
    }
}

