//
//  TodayViewController.swift
//  iosApp
//
//  Created by Tony Wu on 11/21/19.
//  Copyright © 2019 Tony Wu. All rights reserved.
//

import UIKit

class TodayViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let cardIcon = ["weather-windy", "gauge", "weather-pouring", "thermometer", "weather-fog", "water-percent", "eye-outline", "weather-fog", "earth"]
    let cardTitle = ["Wind Speed", "Pressure", "Precipitation", "Temperature", "-", "Humidity", "Visibility", "Cloud Cover", "Ozone"]
    
    var collectionViewFlowLayout: UICollectionViewFlowLayout!
    var currentWeather: CurrentWeather? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
        setupCollectionViewItemSize()
        let tabController = tabBarController as! TabBarController
        currentWeather = tabController.currentWeather
    }
    
    func setupCollectionViewItemSize() {
        if collectionViewFlowLayout == nil {
            let lineSpacing: CGFloat = 20
            let interItemSpacing: CGFloat = 10
            
            let width = (collectionView.visibleSize.width - 2 * interItemSpacing) / 3
            let height = (collectionView.visibleSize.height - 2 * lineSpacing) / 3
            collectionViewFlowLayout = UICollectionViewFlowLayout()
            collectionViewFlowLayout.itemSize = CGSize(width: width, height: height)
//            collectionViewFlowLayout.sectionInset = UIEdgeInsets.zero
            collectionViewFlowLayout.minimumLineSpacing = lineSpacing
            collectionViewFlowLayout.minimumInteritemSpacing = interItemSpacing
            collectionView.setCollectionViewLayout(collectionViewFlowLayout, animated: true)
        }
    }
}

extension TodayViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 4 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCellCenter", for: indexPath) as! CollectionViewCell
            cell.layer.borderColor = UIColor.white.cgColor
            cell.cellCardCenterIcon.image = UIImage(named: (currentWeather?.todayIcon)!)
            cell.cellCardCenterTitle.text = (currentWeather?.todaySummary)!
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as! CollectionViewCell
            cell.layer.borderColor = UIColor.white.cgColor
            cell.cellCardIcon.image = UIImage(named: cardIcon[indexPath.item])
            cell.cellCardTitle.text = cardTitle[indexPath.item]
            switch indexPath.item {
            case 0:
                cell.cellCardData.text = "\(String(describing: (currentWeather?.todayWindSpeed)!)) mph"
            case 1:
                cell.cellCardData.text = "\(String(describing: (currentWeather?.todayPressure)!)) mb"
            case 2:
                cell.cellCardData.text = "\(String(describing: (currentWeather?.todayPrecipitation)!)) mmph"
            case 3:
                cell.cellCardData.text = "\(String(describing: (currentWeather?.todayTemperature)!))℉"
            case 5:
                cell.cellCardData.text = "\(String(describing: (currentWeather?.todayHumidity)!)) ％"
            case 6:
                cell.cellCardData.text = "\(String(describing: (currentWeather?.todayVisibility)!)) km"
            case 7:
                cell.cellCardData.text = "\(String(describing: (currentWeather?.todayCloudCover)!)) ％"
            case 8:
                cell.cellCardData.text = "\(String(describing: (currentWeather?.todayOzone)!)) DU"
            default:
                cell.cellCardData.text = ""
            }
            return cell
        }
    }
}
