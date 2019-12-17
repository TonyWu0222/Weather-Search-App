//
//  CityGeoInfo.swift
//  iosApp
//
//  Created by Tony Wu on 11/25/19.
//  Copyright © 2019 Tony Wu. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class CityGeoInfo {
    
    let getGeoInfoCompleteUrlHead: String = "http://hw9-env-zehaowu.us-west-1.elasticbeanstalk.com/geoInfo?"
    typealias Complete = () -> ()
    
    var latitude: Double! = 0.0
    var longitude: Double! = 0.0
    
    func getGeoInfoComplete(address: String, completed: @escaping Complete) {
        if let getGeoInfoCompleteUrl = URL(string: "\(getGeoInfoCompleteUrlHead)address=\(address)") {
            Alamofire.request(getGeoInfoCompleteUrl).responseJSON(completionHandler: { (response) in
                if let jsonResult = response.result.value {
                    let json = JSON(jsonResult)
                    if json["status"] == "OK" {
                        self.latitude = json["results"].arrayValue[0]["geometry"]["location"]["lat"].double
                        self.longitude = json["results"].arrayValue[0]["geometry"]["location"]["lng"].double
                    }
                    completed()
                }
            })
        }
    }
}
