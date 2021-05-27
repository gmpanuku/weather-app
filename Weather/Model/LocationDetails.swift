//
//  LocationDetails.swift
//  Weather
//
//  Created by Panuku Goutham on 23/05/21.
//

import Foundation

struct LocationDetails: Codable {
    let locationName: String
    let country: String
    let latitude: Double
    let longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case locationName = "LocationName"
        case country = "Country"
        case latitude = "Lat"
        case longitude = "Long"
    }
}
