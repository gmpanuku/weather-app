//
//  MapViewController.swift
//  Weather
//
//  Created by Panuku Goutham on 22/05/21.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var customAnnotationView: UIView!
    private let annotation = MKPointAnnotation()
    lazy var savedLocationViewModel: SavedLocationsViewModel = {
        let viewModal = SavedLocationsViewModel()
        return viewModal
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func handleLongPress(_ gestureReconizer: UILongPressGestureRecognizer)
    {
        if gestureReconizer.state ==  UIGestureRecognizer.State.began {
            let location = gestureReconizer.location(in: mapView)
            let coordinate = mapView.convert(location,toCoordinateFrom: mapView)
            
            mapView.removeAnnotation(annotation)
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
            
            let lat = Double(coordinate.latitude)
            let long = Double(coordinate.longitude)
            self.getAddressFromLatLon(latitude: lat, longitude: long)
        }
    }
}

extension MapViewController {
    private func saveLocation(location: LocationDetails) {
        self.savedLocationViewModel.bindSavedLocationsViewModelToController = {
            print("Location Added successfully")
            NotificationCenter.default.post(name: .didUpdateCitiesData, object: nil)
            self.navigationController?.popViewController(animated: true)
        }
        self.savedLocationViewModel.saveLocation(location: location)
    }
}

extension MapViewController {
    private func getAddressFromLatLon(latitude: Double, longitude: Double)
    {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        center.latitude = latitude
        center.longitude = longitude
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        let ceo: CLGeocoder = CLGeocoder()
        ceo.reverseGeocodeLocation(loc, completionHandler: {(placemarks, error) in
            if (error != nil)
            {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            }
            if let pm = placemarks, pm.count>0 {
                let pm = placemarks![0]
                let locality = pm.locality ?? ""
                let subAdministrativeArea = pm.subAdministrativeArea ?? ""
                let administrativeArea = pm.administrativeArea ?? ""
                let place = !locality.isEmpty ? locality : !subAdministrativeArea.isEmpty ? subAdministrativeArea : administrativeArea
                self.displayCityPopup(placeName: place, country: pm.country ?? "", lat: latitude, long: longitude)
            }
        })
    }
    
    private func displayCityPopup(placeName: String, country: String, lat: Double, long: Double) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: placeName, message: country, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action) in
                let location = LocationDetails(locationName: placeName, country: country, latitude: lat, longitude: long)
                self.saveLocation(location: location)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
