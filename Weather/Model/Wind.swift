//
//  Wind.swift
//  Weather
//
//  Created by Panuku Goutham on 22/05/21.
//

struct Wind: Codable {
    let speed: Double
    
    enum CodingKeys: String, CodingKey {
        case speed
    }

}
