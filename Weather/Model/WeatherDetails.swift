//
//  WeatherDetails.swift
//  Weather
//
//  Created by Panuku Goutham on 22/05/21.
//

struct WeatherDetails: Codable {
    let main: String
    
    enum CodingKeys: String, CodingKey {
        case main
    }
}
