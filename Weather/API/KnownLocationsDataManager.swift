//
//  KnownLocationsDataManager.swift
//  Weather
//
//  Created by Panuku Goutham on 22/05/21.
//

import Foundation

class KnownLocationsDataManager {
    func getKnownLocations(fileName: String, ext: String, completion: @escaping (_ locations: Locations?) -> ()) {
        guard let jsonData = readDataFromFile(fileName: fileName, ext: ext) else {
            return completion(nil)
        }
        self.createKnownLocationsObjectWith(json: jsonData) { (locations) in
            guard let data = locations else {
                return completion(nil)
            }
            return completion(data)
        }
    }
}

extension KnownLocationsDataManager {
    private func readDataFromFile(fileName: String, ext: String) -> Data?{
        do {
            if let file = Bundle.main.url(forResource: fileName, withExtension: ext) {
                let data = try Data(contentsOf: file)
                return data
            }
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    private func createKnownLocationsObjectWith(json: Data, completion: @escaping (_ data: Locations?) -> Void) {
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
