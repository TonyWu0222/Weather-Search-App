//
//  SearchViewController.swift
//  iosApp
//
//  Created by Tony Wu on 11/25/19.
//  Copyright © 2019 Tony Wu. All rights reserved.
//

import UIKit
import SwiftSpinner
import Toast_Swift

protocol PassDataToMainViewController {
    func passData(str: String)
}

class SearchViewController: UIViewController {
    
    var searchAutoComplete: String = ""
    var cityName: String = ""
    
    var latitude: Double! = nil
    var longitude: Double! = nil
    
    var currentWeather: CurrentWeather? = nil
    var mainViewCopy: Slide?
    var isFavortied: Bool = false
    
    var currentCityName: String = ""
    
    var delegate: PassDataToMainViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getCityNameFromString(string: searchAutoComplete)
        setNavigationBar()
        
        //---------------------Spinner------------------------
        SwiftSpinner.show("Fetching Weather Details for \(cityName)")
        
        //--------------------getGeoInfo----------------------
        let cityGeoInfo = CityGeoInfo()
        cityGeoInfo.getGeoInfoComplete(address: searchAutoComplete.replacingOccurrences(of: " ", with: "+"), completed: {
            print(cityGeoInfo.latitude!)
            print(cityGeoInfo.longitude!)
            print(self.cityName)
            self.latitude = cityGeoInfo.latitude!
            self.longitude = cityGeoInfo.longitude!
            let currentWeather: CurrentWeather = CurrentWeather()
            currentWeather.downloadCurrentWeather(latitude: cityGeoInfo.latitude!, longitude: cityGeoInfo.longitude!, cityName: self.cityName, completed: {
                self.currentWeather = currentWeather
                self.loadSlide(currentWeather: self.currentWeather!)
                SwiftSpinner.hide()
            })
            
        })

    }
    
    override func willMove(toParent parent: UIViewController?) {
        delegate.passData(str: cityName)
        print("back")
    }
    
    //---------------NavigationBar-----------------
    func setNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "twitter"), style: .plain, target: self, action: #selector(clickTwitter))
        navigationItem.title = self.cityName
    }
    
    @objc func clickTwitter() {
//        print(currentWeather?.cityName)
        print("https://twitter.com/intent/tweet?text=The current temperature at \(String(describing: (currentWeather?.cityName)!)) is \(String(describing: (currentWeather?.temperature)!))%C2%B0F%2E The weather conditions are \(String(describing: (currentWeather?.summary)!))%2E%23CSCI571WeatherSearch")
//        guard let url = URL(string: "https://twitter.com/intent/tweet?text=The%20current%20temperature%20at%20\(String(describing: (currentWeather?.cityName.replacingOccurrences(of: " ", with: "%20"))!))%20is%20\(String(describing: (currentWeather?.temperature)!))%C2%B0F%2E%20The%20weather%20conditions%20are%20\(String(describing: (currentWeather?.summary)!))%2E%23CSCI571WeatherSearch") else { return }
        let text = "http://twitter.com/intent/tweet?text=The current temperature at \(String(describing: (currentWeather?.cityName)!)) is \(String(describing: (currentWeather?.temperature)!))℉. The weather conditions are \(String(describing: (currentWeather?.summary)!)). &hashtags=CSCI571WeatherSearch"
        let url = URL(string: text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        print(url)
        UIApplication.shared.open(url)
    }
    
    
    //-----------getCityNameFromString-------------
    func getCityNameFromString(string: String) {
        if let index = string.firstIndex(of: ",") {
            let substring = string[..<index]
            let cityName = String(substring)
            self.cityName = cityName
        }
    }
    
    //-----------------SlideCard-------------------
    func loadSlide(currentWeather: CurrentWeather) {
        
        let mainView: Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        self.mainViewCopy = mainView
        mainView.weatherCard.layer.borderColor = UIColor.white.cgColor
        let tapCard = UITapGestureRecognizer(target: self, action: #selector(clickCard))
        mainView.weatherCard.addGestureRecognizer(tapCard)
        let tapButton = UITapGestureRecognizer(target: self, action: #selector(clickButton))
        mainView.favoriteButton.addGestureRecognizer(tapButton)
        
        //----------------Top_Card------------------
        mainView.icon.image = UIImage(named: currentWeather.icon!)
        mainView.temperature.text = "\(String(describing: currentWeather.temperature!))℉"
        mainView.summary.text = "\(String(describing: currentWeather.summary!))"
        mainView.city.text = "\(String(describing: currentWeather.cityName!))"
        
        //---------------Middle_Icon----------------
        mainView.humidity.text = "\(String(describing: currentWeather.humidity!)) ％"
        mainView.windSpeed.text = "\(String(describing: currentWeather.windSpeed!)) mph"
        mainView.visibility.text = "\(String(describing: currentWeather.visibility!)) km"
        mainView.pressure.text = "\(String(describing: currentWeather.pressure!)) mb"
        
        //---------------Bottom_Table---------------
        mainView.weatherTable.dataSource = self
        mainView.weatherTable.delegate = self
        mainView.weatherTable.register(UINib.init(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        mainView.weatherTable.rowHeight = UITableView.automaticDimension
        mainView.weatherTable.allowsSelection = false
        
        //----------------addSubview----------------
        mainView.frame.size = self.view.bounds.size
        self.view.addSubview(mainView)
        
        //--------------favoriteButton--------------
        if currentCityName == cityName {
            mainView.favoriteButton.isHidden = true
        }
        print(UserDefaults.standard.dictionaryRepresentation().keys)
        if UserDefaults.standard.dictionary(forKey: "Favorite") != nil {
            if UserDefaults.standard.dictionary(forKey: "Favorite")!.keys.contains(cityName) {
                mainView.favoriteButton.setImage(UIImage(named: "trash-can"), for: .normal)
                isFavortied = true
            }
        }
    }
    
    @objc func clickCard() {
        performSegue(withIdentifier: "clickSearchResultCard", sender: self)
    }
    
    @objc func clickButton() {
        if isFavortied == false {
            self.mainViewCopy?.favoriteButton.setImage(UIImage(named: "trash-can"), for: .normal)
            isFavortied = true
            if UserDefaults.standard.dictionary(forKey: "Favorite") == nil {
                let geoDict: [String: [Double]] = [cityName: [self.latitude, self.longitude]]
                UserDefaults.standard.set(geoDict, forKey: "Favorite")
            } else {
                if var geoDict = UserDefaults.standard.dictionary(forKey: "Favorite") {
                    geoDict[cityName] = [self.latitude, self.longitude]
                    UserDefaults.standard.set(geoDict, forKey: "Favorite")
                }
            }
            self.view.makeToast("\(cityName) was added to the Favorite List")
        } else {
            self.mainViewCopy?.favoriteButton.setImage(UIImage(named: "plus-circle"), for: .normal)
            isFavortied = false
            if var geoDict = UserDefaults.standard.dictionary(forKey: "Favorite") {
                geoDict.removeValue(forKey: cityName)
                UserDefaults.standard.set(geoDict, forKey: "Favorite")
            }
            self.view.makeToast("\(cityName) was removed from the Favorite List")
        }
        print(UserDefaults.standard.dictionary(forKey: "Favorite")!)
        print(UserDefaults.standard.dictionaryRepresentation().keys)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "clickSearchResultCard" {
            let tabBarController = segue.destination as! TabBarController
            tabBarController.currentWeather = self.currentWeather
        }
        if segue.identifier == "clickSearchItem" {
            if let viewController = segue.destination as? ViewController {
                viewController.favoriteCityName = cityName
            }
        }
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (currentWeather?.dateArray.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.dailyDate.text = currentWeather?.dateArray[indexPath.item]!
        cell.dailyIcon.image = UIImage(named: (currentWeather?.dateIconArray[indexPath.item])!)
        cell.dailySunriseTime.text = currentWeather?.sunriseTimeArray[indexPath.item]!
        cell.dailySunsetTime.text = currentWeather?.sunsetTimeArray[indexPath.item]!
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(tableView.visibleSize.height / 6)
    }
}
