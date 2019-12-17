//
//  ViewController.swift
//  iosApp
//
//  Created by Tony Wu on 11/19/19.
//  Copyright © 2019 Tony Wu. All rights reserved.
//

import UIKit
import SwiftSpinner
import Toast_Swift

class ViewController: UIViewController {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var searchTableView: UITableView!
    var searchAutoCompleteArray: [String?] = []
    var currentAutoCompleteArrayIndex: Int = 0
    
    let searchBar: UISearchBar = UISearchBar()
    var currentWeatherArray: [CurrentWeather] = []
    var currentPageNumber: Int = 0
    
    var currentCityName: String = ""
    var favoriteCityName: String = ""
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "clickWeatherCard" {
            let tabBarController = segue.destination as! TabBarController
            tabBarController.currentWeather = self.currentWeatherArray[currentPageNumber]
        }
        if segue.identifier == "clickSearchItem" {
            let searchViewController = segue.destination as! SearchViewController
            searchViewController.searchAutoComplete = searchAutoCompleteArray[currentAutoCompleteArrayIndex]!
            searchViewController.currentCityName = currentCityName
            searchViewController.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //---------------------Spinner------------------------
        SwiftSpinner.show("Loading...")
        
        //-----------------Current_Location-------------------
        let currentLocation: CurrentLocation = CurrentLocation()
        currentLocation.getCurrentLocation()
        print(currentLocation.latitude!)
        print(currentLocation.longitude!)
        currentLocation.getCurrentCityName(completed: {
            self.currentCityName = currentLocation.cityName
            //--------------------SearchBar-----------------------
            let backItem = UIBarButtonItem()
            backItem.title = "Weather"
            self.navigationItem.backBarButtonItem = backItem
            self.loadSearchBar()
            self.loadSearchTable()

            //-----------------Current_Weather--------------------
            let currentWeather: CurrentWeather = CurrentWeather()
            currentWeather.downloadCurrentWeather(latitude: currentLocation.latitude!, longitude: currentLocation.longitude!, cityName: currentLocation.cityName, completed: {
                self.currentWeatherArray.append(currentWeather)
                if UserDefaults.standard.dictionary(forKey: "Favorite") != nil {
                    print("=============================")
                    print(UserDefaults.standard.dictionary(forKey: "Favorite")!)
                    print(UserDefaults.standard.dictionary(forKey: "Favorite")!.keys.count)
                    if UserDefaults.standard.dictionary(forKey: "Favorite")!.keys.count == 0 {
                        self.loadSlide(currentWeatherArray: self.currentWeatherArray)
                        SwiftSpinner.hide()
                    } else {
                        let favoriteDicts = UserDefaults.standard.dictionary(forKey: "Favorite")!
                        for favoriteDict in favoriteDicts {
                            print("\(favoriteDict.key)")
                            let geoInfo: [Double] = favoriteDict.value as! [Double]
                            print(geoInfo[0])
                            print(geoInfo[1])

                            let currentWeather: CurrentWeather = CurrentWeather()
                            currentWeather.downloadCurrentWeather(latitude: geoInfo[0], longitude: geoInfo[1], cityName: favoriteDict.key, completed: {
                                self.currentWeatherArray.append(currentWeather)
                                self.scrollView.subviews.forEach({ $0.removeFromSuperview() })
                                self.loadSlide(currentWeatherArray: self.currentWeatherArray)
                                SwiftSpinner.hide()
                            })
                        }
                        print("-----------------------------")
                    }
                } else {
                    self.loadSlide(currentWeatherArray: self.currentWeatherArray)
                    SwiftSpinner.hide()
                }
            })

        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if favoriteCityName != "" {
            print("favoriteCityName: \(favoriteCityName)")
            if UserDefaults.standard.dictionary(forKey: "Favorite") != nil {
                let favoriteDicts = UserDefaults.standard.dictionary(forKey: "Favorite")! as Dictionary
                if favoriteDicts.keys.contains(favoriteCityName) {
                    var addCity: Bool = true
                    for index in 0..<currentWeatherArray.count {
                        if favoriteCityName == currentWeatherArray[index].cityName {
                            addCity = false
                        }
                    }
                    if addCity {
                        let favoriteCityGeoInfo: [Double] = favoriteDicts[favoriteCityName] as! [Double]
                        print(favoriteCityGeoInfo[0])
                        print(favoriteCityGeoInfo[1])
                        
                        let currentWeather: CurrentWeather = CurrentWeather()
                        currentWeather.downloadCurrentWeather(latitude: favoriteCityGeoInfo[0], longitude: favoriteCityGeoInfo[1], cityName: favoriteCityName, completed: {
                            self.currentWeatherArray.append(currentWeather)
                            self.scrollView.subviews.forEach({ $0.removeFromSuperview() })
                            self.loadSlide(currentWeatherArray: self.currentWeatherArray)
                        })
                    }
                } else {
                    var removeIndex: Int = -1
                    for index in 0..<currentWeatherArray.count {
                        if favoriteCityName != currentCityName && favoriteCityName == currentWeatherArray[index].cityName {
                            removeIndex = index
                        }
                    }
                    if removeIndex != -1 {
                        currentWeatherArray.remove(at: removeIndex)
                        if currentWeatherArray.count <= currentPageNumber {
                            currentPageNumber -= 1
                        }
                        self.scrollView.subviews.forEach({ $0.removeFromSuperview() })
                        self.loadSlide(currentWeatherArray: currentWeatherArray)
                    }
                }
            }
            
            
//            print(favoriteDicts[favoriteCityName]!)
            favoriteCityName = ""
        }
    }
    
    //-----------------SearchBar--------------------
    func loadSearchBar() {
        searchBar.placeholder = "Enter City Name..."
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        scrollView.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap() {
        searchBar.endEditing(true)
    }
    
    //----------------SearchTable------------------
    func loadSearchTable() {
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.register(UINib.init(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")
        searchTableView.rowHeight = UITableView.automaticDimension
        searchTableView.isHidden = true
        searchTableView.layer.cornerRadius = 15
        searchTableView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        searchTableView.allowsSelection = true
    }
    
    //-----------------SlideCard-------------------
    func loadSlide(currentWeatherArray: [CurrentWeather]) {
        pageControl.numberOfPages = currentWeatherArray.count
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: (scrollView.frame.size.width * CGFloat(currentWeatherArray.count)), height: scrollView.frame.size.height)
        for index in 0..<currentWeatherArray.count {
            let mainView: Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
            if index == 0 {
                mainView.favoriteButton.isHidden = true
            }
            mainView.favoriteButton.setImage(UIImage(named: "trash-can"), for: .normal)
            
            mainView.weatherCard.layer.borderColor = UIColor.white.cgColor
            let tapCard = UITapGestureRecognizer(target: self, action: #selector(clickCard))
            mainView.weatherCard.addGestureRecognizer(tapCard)
            let tapButton = UITapGestureRecognizer(target: self, action: #selector(clickButton))
            mainView.favoriteButton.addGestureRecognizer(tapButton)
            
            //----------------Top_Card------------------
            mainView.icon.image = UIImage(named: currentWeatherArray[index].icon!)
            mainView.temperature.text = "\(String(describing: currentWeatherArray[index].temperature!))℉"
            mainView.summary.text = "\(String(describing: currentWeatherArray[index].summary!))"
            mainView.city.text = "\(String(describing: currentWeatherArray[index].cityName!))"
            
            //---------------Middle_Icon----------------
            mainView.humidity.text = "\(String(describing: currentWeatherArray[index].humidity!)) ％"
            mainView.windSpeed.text = "\(String(describing: currentWeatherArray[index].windSpeed!)) mph"
            mainView.visibility.text = "\(String(describing: currentWeatherArray[index].visibility!)) km"
            mainView.pressure.text = "\(String(describing: currentWeatherArray[index].pressure!)) mb"
            
            //---------------Bottom_Table---------------
            mainView.weatherTable.dataSource = self
            mainView.weatherTable.delegate = self
            mainView.weatherTable.register(UINib.init(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
            mainView.weatherTable.rowHeight = UITableView.automaticDimension
            mainView.weatherTable.allowsSelection = false
            
            //--------------scrollView------------------
            self.scrollView.addSubview(mainView)
            mainView.frame.size = self.view.bounds.size
            mainView.frame.origin.x = self.view.bounds.size.width * CGFloat(index)
        }
    }
    
    @objc func clickCard() {
        searchBar.endEditing(true)
        performSegue(withIdentifier: "clickWeatherCard", sender: self)
    }
    
    @objc func clickButton() {
        self.scrollView.subviews.forEach({ $0.removeFromSuperview() })
        self.view.makeToast("\(String(describing: (self.currentWeatherArray[currentPageNumber].cityName)!)) was removed from the Favorite List")
        if var geoDict = UserDefaults.standard.dictionary(forKey: "Favorite") {
            geoDict.removeValue(forKey: (self.currentWeatherArray[currentPageNumber].cityName)!)
            UserDefaults.standard.set(geoDict, forKey: "Favorite")
        }
        self.currentWeatherArray.remove(at: currentPageNumber)
        if self.currentWeatherArray.count <= currentPageNumber {
            currentPageNumber -= 1
        }
        self.loadSlide(currentWeatherArray: self.currentWeatherArray)
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        currentPageNumber = Int(pageNumber)
        pageControl.currentPage = currentPageNumber
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == searchTableView {
            return self.searchAutoCompleteArray.count
        } else {
            return currentWeatherArray[currentPageNumber].dateArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == searchTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
            cell.searchResultText.text = (self.searchAutoCompleteArray[indexPath.item])!
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
            cell.dailyDate.text = currentWeatherArray[currentPageNumber].dateArray[indexPath.item]!
            cell.dailyIcon.image = UIImage(named: currentWeatherArray[currentPageNumber].dateIconArray[indexPath.item]!)
            cell.dailySunriseTime.text = currentWeatherArray[currentPageNumber].sunriseTimeArray[indexPath.item]!
            cell.dailySunsetTime.text = currentWeatherArray[currentPageNumber].sunsetTimeArray[indexPath.item]!
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == searchTableView {
            return CGFloat(tableView.visibleSize.height / 5)
        } else {
            return CGFloat(tableView.visibleSize.height / 6)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == searchTableView {
            currentAutoCompleteArrayIndex = indexPath.item
            let cell = tableView.cellForRow(at: indexPath) as! SearchTableViewCell
            print("\(String(describing: cell.searchResultText.text))")
            performSegue(withIdentifier: "clickSearchItem", sender: self)
            self.searchTableView.isHidden = true
            searchBar.endEditing(true)
        }
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            searchTableView.isHidden = true
        } else {
            let searchAutoComplete = SearchAutoComplete()
            searchAutoComplete.downloadAutoComplete(cityName: searchText.replacingOccurrences(of: " ", with: "%20"), completed: {
                if searchAutoComplete.status == "ZERO_RESULTS" {
                    self.searchTableView.isHidden = true
                } else {
                    self.searchTableView.isHidden = false
                    self.searchAutoCompleteArray = searchAutoComplete.searchAutoCompleteArray
                }
                self.searchTableView.reloadData()
            })
        }
    }
}

extension ViewController: PassDataToMainViewController {
    func passData(str: String) {
        favoriteCityName = str
    }
}
