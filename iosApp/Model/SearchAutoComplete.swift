//
//  SearchAutoComplete.swift
//  iosApp
//
//  Created by Tony Wu on 11/24/19.
//  Copyright © 2019 Tony Wu. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class SearchAutoComplete {
    
    let searchAutoCompleteUrlHead: String = "http://hw9-env-zehaowu.us-west-1.elasticbeanstalk.com/autoComplete?"
    typealias DownloadComplete = () -> ()
    
    var status: String = ""
    var searchAutoCompleteArray: [String?] = []
    
    func downloadAutoComplete(cityName: String, completed: @escaping DownloadComplete) {
        if let searchAutoCompleteUrl = URL(string: "\(searchAutoCompleteUrlHead)input=\(cityName)") {
            Alamofire.request(searchAutoCompleteUrl).responseJSON(completionHandler: { (response) in
                if let jsonResult = response.result.value {
                    let json = JSON(jsonResult)
                    if json["status"] == "ZERO_RESULTS" {
                        self.status = "ZERO_RESULTS"
                    } else {
                        self.status = "OK"
                        let predictions = json["predictions"].arrayValue
                        for index in 0..<predictions.count {
                            self.searchAutoCompleteArray.append(predictions[index]["description"].stringValue)
                        }
                    }
                    completed()
                }
            })
        }
    }
}
