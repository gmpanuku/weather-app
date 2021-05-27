//
//  Locations.swift
//  Weather
//
//  Created by Panuku Goutham on 23/05/21.
//

import Foundation

struct Locations: Codable {
    var locations: [LocationDetails]?
    
    enum CodingKeys: String, CodingKey {
        case locations = "locations"
    }
}
