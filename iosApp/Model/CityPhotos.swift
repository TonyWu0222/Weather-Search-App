//
//  CityPhotos.swift
//  iosApp
//
//  Created by Tony Wu on 11/23/19.
//  Copyright © 2019 Tony Wu. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class CityPhotos {
    
    let cityPhotosSearchUrlHead: String = "http://hw9-env-zehaowu.us-west-1.elasticbeanstalk.com/photos?"
    typealias DownloadComplete = () -> ()
    
    var cityPhotoUrlArray: [String?] = []
    
    func downloadCityPhotos(cityName: String, completed: @escaping DownloadComplete) {
        if let cityPhotosSearchUrl = URL(string: "\(cityPhotosSearchUrlHead)city=\(cityName)") {
            Alamofire.request(cityPhotosSearchUrl).responseJSON(completionHandler: { (response) in
                if let jsonResult = response.result.value {
                    let json = JSON(jsonResult)
                    let items = json["items"].arrayValue
                    for index in 0..<items.count {
                        self.cityPhotoUrlArray.append(items[index]["link"].stringValue)
                    }
                    completed()
                }
            })
        }
    }
    
}
