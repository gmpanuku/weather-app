//
//  SettingsViewController.swift
//  Weather
//
//  Created by Panuku Goutham on 23/05/21.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var settingsTableView: UITableView! {
        didSet {
            settingsTableView.delegate = self
            settingsTableView.dataSource = self
            settingsTableView.tableFooterView = UIView()
        }
    }
    lazy var savedLocationViewModel: SavedLocationsViewModel = {
        let viewModal = SavedLocationsViewModel()
        return viewModal
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Settings"
        settingsTableView.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier.DefaultCell.rawValue)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateSettings), name: .didUpdateSettingTable, object: nil)

    }
    
    @objc func updateSettings(notification: Notification) {
        settingsTableView.reloadData()
    }

}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.SettingsCell.rawValue, for: indexPath) as! SettingsTableViewCell
            let tempUnits = UserDefaults.standard.value(forKey: Constants.tempUnits) as? String ?? Constants.metric
            if tempUnits == Constants.metric {
                cell.metricUnitsButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
                cell.imperialUnitsButton.setImage(UIImage(named: ""), for: .normal)
            } else {
                cell.metricUnitsButton.setImage(UIImage(named: ""), for: .normal)
                cell.imperialUnitsButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            }
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.DefaultCell.rawValue, for: indexPath)
            cell.selectionStyle = .none
            cell.textLabel?.text = "Reset Saved Cities"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Are you sure, You want to reset saved cities?", message: "", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                    alert.dismiss(animated: true) {
                        let isDeleted = self.savedLocationViewModel.removeAllLocations()
                        if isDeleted {
                            DispatchQueue.main.async {
                                NotificationCenter.default.post(name: .didUpdateCitiesData, object: nil)
                                let alert = UIAlertController(title: "Reset Saved Cities Successfull", message: "", preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
}
