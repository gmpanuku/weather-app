//
//  CityWeatherViewController.swift
//  Weather
//
//  Created by Panuku Goutham on 22/05/21.
//

import UIKit

class CityWeatherViewController: UIViewController {
    @IBOutlet weak var weatherTableView: UITableView! {
        didSet {
            weatherTableView.delegate = self
            weatherTableView.dataSource = self
            weatherTableView.tableFooterView = UIView()
        }
    }
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    var location: LocationDetails?
    
    lazy var weatherViewModel: WeatherViewModel = {
        let viewModal = WeatherViewModel(location: location)
        return viewModal
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = location?.locationName
        weatherTableView.isHidden = true
        spinner.startAnimating()
        getWeatherViewModel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let indexPath = IndexPath(row: 1, section: 0)
        let tableViewCell: WeatherDetailsTableViewCell = weatherTableView.cellForRow(at: indexPath) as! WeatherDetailsTableViewCell
        tableViewCell.weatherDetailsCollectionView.collectionViewLayout.invalidateLayout()
    }
}

extension CityWeatherViewController {
    
    private func getWeatherViewModel() {
        self.weatherViewModel =  WeatherViewModel(location: location)
        self.weatherViewModel.bindWeatherViewModelToController = {
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                self.weatherTableView.isHidden = false
                self.weatherTableView.reloadData()
            }
        }
        self.weatherViewModel.errorHandling = { error in
            let alert = UIAlertController(title: error, message: "", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        self.weatherViewModel.getWeather(apiType: APIType.todayForecast)
    }
}

extension CityWeatherViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.TempCell.rawValue, for: indexPath) as! TempTableViewCell
            cell.tempLabel.text = weatherViewModel.currentTempString
            cell.weatherLabel.text = weatherViewModel.weatherString
            cell.highLowTempLabel.text = weatherViewModel.highLowTempString
            cell.dayLabel.text = weatherViewModel.dayString
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.WeatherDetailsCell.rawValue, for: indexPath) as! WeatherDetailsTableViewCell
            cell.weatherViewModel = self.weatherViewModel
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return UITableView().estimatedRowHeight
        } else {
            let count = weatherViewModel.weatherDetailsArray.count
            return CGFloat(((count/2)*84)+((count%2)*84)+71)
        }
    }
    
}
