//
//  ForecastService.swift
//  iosApp
//
//  Created by Tony Wu on 11/20/19.
//  Copyright © 2019 Tony Wu. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ForecastService {
    
    let weatherSearchUrlHead: String = "http://localhost:3000/weatherSearch?"
    typealias DownloadComplete = () -> ()
    
    func getWeatherInfo(latitude: Double, longitude: Double, completed: @escaping DownloadComplete) {
        if let weatherSearchURL = URL(string: "\(weatherSearchUrlHead)latitude=\(latitude)&longitude=\(longitude)") {
            Alamofire.request(weatherSearchURL).responseJSON(completionHandler: { (response) in
                if let jsonResult = response.result.value {
                    let json = JSON(jsonResult)
                    print(json["currently"])
                    completed()
                }
            })
        }
        
    }
}
