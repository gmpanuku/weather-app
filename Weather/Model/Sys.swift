//
//  Sys.swift
//  Weather
//
//  Created by Panuku Goutham on 22/05/21.
//

struct Sys: Codable {
    let sunrise: Int
    let sunset: Int
    
    enum CodingKeys: String, CodingKey {
        case sunrise
        case sunset
    }
}
