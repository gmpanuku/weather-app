//
//  SavedLocationsViewModel.swift
//  Weather
//
//  Created by Panuku Goutham on 23/05/21.
//

import Foundation

class SavedLocationsViewModel {

    private var localDbManager: LocalDBManager?
    var locations : Locations? {
        didSet {
            self.bindSavedLocationsViewModelToController()
        }
    }
    
    var bindSavedLocationsViewModelToController : (() -> ()) = {}

    init() {
        self.localDbManager =  LocalDBManager()
    }
    
    func getSavedLocations() {
        getSavedLocationsFromLocalDB()
    }
    
    func saveLocation(location: LocationDetails) {
        saveLocationInLocalDB(location: location)
    }
    
    func removeLocation(viewModel: SavedLocationsViewModel, index: Int) {
        removeLocationFromLocalDB(viewModel: viewModel, index: index)
    }
    
    func removeAllLocations() -> Bool{
        return ((self.localDbManager?.deleteAllLocationFromDB()) != nil)
    }
    
}

extension SavedLocationsViewModel {
    
    private func getSavedLocationsFromLocalDB() {
        self.localDbManager?.getLocationsFromLocalDB(completion: { (savedLocations) in
            self.locations = savedLocations
        })
    }
    
    private func saveLocationInLocalDB(location: LocationDetails) {
        self.localDbManager?.saveLocationInLocalDB(location: location, completion: { (savedLocations) in
            guard let savedLocations = savedLocations  else { return }
            self.locations = savedLocations
            print("saved locations object:", savedLocations)
        })
    }
    
    private func removeLocationFromLocalDB(viewModel: SavedLocationsViewModel, index: Int) {
        self.localDbManager?.deleteLocationFromDB(savedLocationViewModel: viewModel, at: index, completion: { (savedLocations) in
            guard let savedLocations = savedLocations  else { return }
            self.locations = savedLocations
            print("saved locations object:", savedLocations)
        })

    }
    
}
