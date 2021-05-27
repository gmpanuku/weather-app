//
//  WeatherDetailsTableViewCell.swift
//  Weather
//
//  Created by Panuku Goutham on 22/05/21.
//

import UIKit

class WeatherDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var weatherDetailsCollectionView: UICollectionView! {
        didSet {
            weatherDetailsCollectionView.delegate = self
            weatherDetailsCollectionView.dataSource = self
        }
    }
    
    var weatherViewModel: WeatherViewModel? {
        didSet {
            DispatchQueue.main.async {
                self.weatherDetailsCollectionView.reloadData()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if let flowLayout = self.weatherDetailsCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = .zero
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension WeatherDetailsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherViewModel?.weatherDetailsArray.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.WeatherDetailsCollectionViewCell.rawValue, for: indexPath as IndexPath) as! WeatherDetailsCollectionViewCell
        let dict = weatherViewModel?.weatherDetailsArray[indexPath.item] as? [String: Any] ?? [String: Any]()
        cell.valueLabel.text = dict["value"] as? String ?? ""
        cell.descLabel.text = dict["desc"] as? String ?? ""
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let orientation = UIApplication.shared.windows.first!.windowScene!.interfaceOrientation
        if(orientation == .landscapeLeft || orientation == .landscapeRight)
        {
            return CGSize(width: (screenHeight-80)/2, height: 84)
        }
        else{
            return CGSize(width: (screenWidth-80)/2, height: 84)
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 1
    }
}
