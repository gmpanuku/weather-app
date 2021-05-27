//
//  SettingsTableViewCell.swift
//  Weather
//
//  Created by Panuku Goutham on 23/05/21.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var metricUnitsButton: UIButton!
    @IBOutlet weak var imperialUnitsButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func unitsButtonAction(_ sender: UIButton) {
        var unitsSelected = Constants.metric
        if sender == imperialUnitsButton {
            unitsSelected = Constants.imperial
        }
        UserDefaults.standard.set(unitsSelected, forKey: Constants.tempUnits)
        NotificationCenter.default.post(name: .didUpdateSettingTable, object: nil)
    }
    
}
