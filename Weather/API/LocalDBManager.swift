//
//  LocalDBManager.swift
//  Weather
//
//  Created by Panuku Goutham on 23/05/21.
//

import Foundation

class LocalDBManager {
    
    func saveLocationInLocalDB(location: LocationDetails, completion: @escaping (_ data: Locations?) -> ()) {
        
        if isDataAvailableInLocalDB() {
            getLocationsFromLocalDB { (knownLocations) in
                guard var locations = knownLocations else {
                    return completion(nil)
                }
                print(locations)
                guard let locationDetailsArray = locations.locations else {
                    return completion(nil)
                }
                if !locationDetailsArray.contains(where: { $0.locationName == location.locationName })  {
                    locations.locations?.append(location)
                    self.saveLocation(savedLocations: locations)
                    return completion(locations)
                }
                return completion(locations)
            }
        } else {
            print("No data found")
            let array = [location]
            let savedLocation = Locations(locations: array)
            self.saveLocation(savedLocations: savedLocation)
            return completion(savedLocation)
        }
    }
    
    func getLocationsFromLocalDB(completion: @escaping (_ locations: Locations?) -> ()) {
        guard let jsonData = getLocations() else {
            return completion(nil)
        }
        self.createSavedLocationsObjectWith(json: jsonData) { (locations) in
            guard let data = locations else {
                return completion(nil)
            }
            return completion(data)
        }
    }
    
    func deleteLocationFromDB(savedLocationViewModel: SavedLocationsViewModel?, at index: Int, completion: @escaping (_ locations: Locations?) -> Void) {
        guard let locationsViewModel = savedLocationViewModel else {
            return completion(nil)
        }
        locationsViewModel.locations?.locations?.remove(at: index)
        guard let locations = locationsViewModel.locations else {
            return completion(nil)
        }
        self.saveLocation(savedLocations: locations)
        return completion(locations)
    }
    
    func deleteAllLocationFromDB() -> Bool {
        UserDefaults.standard.removeObject(forKey: Constants.savedLocations)
        return isDataAvailableInLocalDB()
    }
    
}

extension LocalDBManager {
    
    private func saveLocation(savedLocations: Locations) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(savedLocations) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: Constants.savedLocations)
        }
    }
    
    private func isDataAvailableInLocalDB() -> Bool {
        if UserDefaults.standard.data(forKey: Constants.savedLocations) != nil {
            return true
        }
        return false
    }
    
    private func getLocations() -> Data?{
        if let data = UserDefaults.standard.data(forKey: Constants.savedLocations) {
            return data
        }
        return nil
    }
    
    private func createSavedLocationsObjectWith(json: Data, completion: @escaping (_ data: Locations?) -> Void) {
        do {
            let decoder = JSONDecoder()
            let locationData = try decoder.decode(Locations.self, from: json)
            return completion(locationData)
        } catch let error {
            print("Error creating known locations object from JSON because: \(error.localizedDescription)")
            return completion(nil)
        }
    }
}
