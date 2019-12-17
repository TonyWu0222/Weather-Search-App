//
//  TabBarController.swift
//  iosApp
//
//  Created by Tony Wu on 11/21/19.
//  Copyright © 2019 Tony Wu. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    var currentWeather: CurrentWeather? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "twitter"), style: .plain, target: self, action: #selector(clickTwitter))
        navigationItem.title = (currentWeather?.cityName)!
//        print("navigationItem.title: \((currentWeather?.cityName)!)")
    }
    
    //---------------NavigationBar-----------------
    @objc func clickTwitter() {
        guard let url = URL(string: "https://twitter.com/intent/tweet?text=The%20current%20temperature%20at%20\(String(describing: (currentWeather?.cityName.replacingOccurrences(of: " ", with: "%20"))!))%20is%20\(String(describing: (currentWeather?.temperature)!))%C2%B0F%2E%20The%20weather%20conditions%20are%20\(String(describing: (currentWeather?.summary)!))%2E%23CSCI571WeatherSearch") else { return }
        UIApplication.shared.open(url)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
