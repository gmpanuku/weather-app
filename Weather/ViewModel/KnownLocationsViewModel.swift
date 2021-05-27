//
//  KnownLocationsViewModel.swift
//  Weather
//
//  Created by Panuku Goutham on 22/05/21.
//

import Foundation

class KnownLocationsViewModel {

    var locationsArray: [LocationDetails]?
    var locationsSearchArray: [LocationDetails]?
    private var locationDataManager: KnownLocationsDataManager?
    private(set) var locations : Locations? {
        didSet {
            self.updateProperties()
        }
    }

    init() {
        self.locationDataManager =  KnownLocationsDataManager()
    }
    
    func getKnownLocations(fileName: String, ext: String) {
        getKnownLocationsFromJsonFile(fileName: fileName, ext: ext)
    }
    
    private func updateProperties() {
        guard let locations = self.locations else { return }
        locationsArray = setLocationsArray(knownLocations: locations)
        locationsSearchArray = locationsArray
    }

}

extension KnownLocationsViewModel {
    
    private func getKnownLocationsFromJsonFile(fileName: String, ext: String) {
        self.locationDataManager?.getKnownLocations(fileName: fileName, ext: ext, completion: { (konwnLocations) in
            guard let konwnLocations = konwnLocations  else { return }
            self.locations = konwnLocations
            print("known locations object:", konwnLocations)
        })
    }

    private func setLocationsArray(knownLocations: Locations) -> [LocationDetails] {
        let locationsArray = knownLocations.locations
        let sortedLocationsArray = locationsArray?.sorted {
            $0.locationName < $1.locationName
        }
        if let array = sortedLocationsArray {
            return array
        }
        return [LocationDetails]()
    }
}



