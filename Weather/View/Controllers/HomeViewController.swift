//
//  HomeViewController.swift
//  Weather
//
//  Created by Panuku Goutham on 22/05/21.
//

import UIKit

public var screenHeight: CGFloat {
    return UIScreen.main.bounds.height
}
public var screenWidth: CGFloat {
    return UIScreen.main.bounds.width
}

class HomeViewController: UIViewController {
    @IBOutlet weak var citiesTableView: UITableView! {
        didSet {
            citiesTableView.delegate = self
            citiesTableView.dataSource = self
            citiesTableView.tableFooterView = UIView()
            citiesTableView.isHidden = true
        }
    }
    @IBOutlet var knownLocationsView: UIView!
    @IBOutlet weak var knownLocationsTableView: UITableView! {
        didSet {
            knownLocationsTableView.delegate = self
            knownLocationsTableView.dataSource = self
            knownLocationsTableView.tableFooterView = UIView()
        }
    }
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
            searchBar.placeholder = "Search city"
        }
    }
    lazy var knownLocationViewModel: KnownLocationsViewModel = {
        let viewModal = KnownLocationsViewModel()
        return viewModal
    }()
    
    lazy var savedLocationViewModel: SavedLocationsViewModel = {
        let viewModal = SavedLocationsViewModel()
        return viewModal
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.getSavedLocations), name: .didUpdateCitiesData, object: nil)
        knownLocationsTableView.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier.DefaultCell.rawValue)
        getKnownLocations()
        getSavedLocations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    @IBAction func addCityButtonAction(_ sender: Any) {
        let mapVC = self.storyboard?.instantiateViewController(identifier: ViewControllerIdentifier.MapViewController.rawValue) as! MapViewController
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
    
    @IBAction func settingsButtonAction(_ sender: Any) {
        let settingsVC = self.storyboard?.instantiateViewController(identifier: ViewControllerIdentifier.SettingsViewController.rawValue) as! SettingsViewController
        self.navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    @IBAction func helpButtonAction(_ sender: Any) {
        let helpVC = self.storyboard?.instantiateViewController(identifier: ViewControllerIdentifier.HelpViewController.rawValue) as! HelpViewController
        self.navigationController?.pushViewController(helpVC, animated: true)
    }
    
}

extension HomeViewController {
    
    func getKnownLocations() {
        self.knownLocationViewModel.getKnownLocations(fileName: "Locations", ext: "json")
    }
    
    @objc private func getSavedLocations() {
        self.savedLocationViewModel.bindSavedLocationsViewModelToController = {
            if let count = self.savedLocationViewModel.locations?.locations?.count, count>0 {
                self.citiesTableView.isHidden = false
                self.citiesTableView.reloadData()
            } else {
                self.citiesTableView.isHidden = true
            }
        }
        self.savedLocationViewModel.getSavedLocations()
    }
    
    private func saveLocation(location: LocationDetails) {
        self.savedLocationViewModel.bindSavedLocationsViewModelToController = {
            if(self.knownLocationsView.isDescendant(of: self.view)) {
                self.knownLocationsView.removeFromSuperview()
            }
            self.searchBar.text = ""
            self.searchBar.resignFirstResponder()
            self.searchBar.showsCancelButton = false
            self.citiesTableView.isHidden = false
            self.citiesTableView.reloadData()
        }
        self.savedLocationViewModel.saveLocation(location: location)
    }
    
    private func removeLocation(index: Int) {
        self.savedLocationViewModel.bindSavedLocationsViewModelToController = {
            self.citiesTableView.reloadData()
        }
        self.savedLocationViewModel.removeLocation(viewModel: savedLocationViewModel, index: index)
    }

}

extension HomeViewController:  UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == knownLocationsTableView {
            return knownLocationViewModel.locationsArray?.count ?? 0
        }
        return savedLocationViewModel.locations?.locations?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == knownLocationsTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.DefaultCell.rawValue, for: indexPath)
            cell.selectionStyle = .none
            let location = knownLocationViewModel.locationsArray?[indexPath.row]
            cell.textLabel?.text = location?.locationName
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.CityCell.rawValue, for: indexPath) as! CityTableViewCell
            let location = savedLocationViewModel.locations?.locations?[indexPath.row]
            cell.cityNameLabel.text = location?.locationName
            cell.countryLabel.text = location?.country
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == knownLocationsTableView {
            return 60
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == knownLocationsTableView {
            guard let location = knownLocationViewModel.locationsArray?[indexPath.row] else { return }
            saveLocation(location: location)
        } else {
            let location = savedLocationViewModel.locations?.locations?[indexPath.row]
            let cityVC = self.storyboard?.instantiateViewController(identifier: ViewControllerIdentifier.CityWeatherViewController.rawValue) as! CityWeatherViewController
            cityVC.location = location
            self.navigationController?.pushViewController(cityVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {

        return true

    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            removeLocation(index: indexPath.row)
        }
    }
}

extension HomeViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.searchBar.showsCancelButton = true
        if(knownLocationsView.isDescendant(of: self.view)) {
            knownLocationsView.removeFromSuperview()
        }
        knownLocationsView.removeFromSuperview()
        self.view.addSubview(knownLocationsView)
        self.view.bringSubviewToFront(knownLocationsView)
        DispatchQueue.main.async {
            self.knownLocationsTableView.reloadData()
        }
        if let lView = knownLocationsView {
            lView.translatesAutoresizingMaskIntoConstraints = false
            view.addConstraint(NSLayoutConstraint(item: lView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: lView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: lView, attribute: .top, relatedBy: .equal, toItem: self.searchBar, attribute: .bottom, multiplier: 1, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: lView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0))
        }
        
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        knownLocationViewModel.locationsArray = searchText.isEmpty ? knownLocationViewModel.locationsSearchArray : knownLocationViewModel.locationsSearchArray?.filter { $0.locationName.contains(searchText) }
        DispatchQueue.main.async {
            self.knownLocationsTableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.searchBar.showsCancelButton = false
        knownLocationViewModel.locationsArray = knownLocationViewModel.locationsSearchArray
        DispatchQueue.main.async {
            self.knownLocationsTableView.reloadData()
        }
        if(knownLocationsView.isDescendant(of: self.view)) {
            knownLocationsView.removeFromSuperview()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}

