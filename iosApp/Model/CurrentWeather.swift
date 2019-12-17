//
//  CurrentWeather.swift
//  iosApp
//
//  Created by Tony Wu on 11/20/19.
//  Copyright © 2019 Tony Wu. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class CurrentWeather {
    //---------------------------Main_Page--------------------------
    //    First_Sub_View
    var icon: String! = ""
    var temperature: Int! = 0
    var summary: String! = "Loading"
    var cityName: String! = "Loading"
    var timeZone: String! = ""
    
    //    Second_Sub_View
    var humidity: Double! = 0.0
    var windSpeed: Double! = 0.0
    var visibility: Double! = 0.0
    var pressure: Double! = 0.0
    
    //    Third_Sub_View
    var dateArray: [String?] = []
    var dateIconArray: [String?] = []
    var sunriseTimeArray: [String?] = []
    var sunsetTimeArray: [String?] = []
    
    //---------------------------Today_Page--------------------------
    //    Arround_Card
    var todayWindSpeed: Double! = 0.0
    var todayPressure: Double! = 0.0
    var todayPrecipitation: Double! = 0.0
    var todayTemperature: Int! = 0
    var todayHumidity: Double! = 0.0
    var todayVisibility: Double! = 0.0
    var todayCloudCover: Double! = 0.0
    var todayOzone: Double! = 0.0
    
    //    Center_Card
    var todayIcon: String! = ""
    var todaySummary: String! = ""
    
    //---------------------------Weekly_Page--------------------------
    //    Top_Card
    var weeklyIcon: String! = ""
    var weeklySummary: String! = ""
    
    //    Bottom_Figure
    var temperatureMinArray: [Int?] = []
    var temperatureMaxArray: [Int?] = []
    
    //-----------------------------Extra------------------------------
    typealias DownloadComplete = () -> ()
    let weatherSearchUrlHead: String = "http://hw9-env-zehaowu.us-west-1.elasticbeanstalk.com/weatherSearch?"
    
    
    
    func downloadCurrentWeather(latitude: Double, longitude: Double, cityName: String, completed: @escaping DownloadComplete) {
        if let weatherSearchURL = URL(string: "\(weatherSearchUrlHead)latitude=\(latitude)&longitude=\(longitude)") {
            Alamofire.request(weatherSearchURL).responseJSON(completionHandler: { (response) in
                if let jsonResult = response.result.value {
                    let json = JSON(jsonResult)
                    
                    //---------------------------Main_Page--------------------------
                    //    First_Sub_View
                    self.icon = self.convertIconName(iconName: json["currently"]["icon"].stringValue)
                    self.temperature = Int(round(json["currently"]["temperature"].double!))
                    self.summary = json["currently"]["summary"].stringValue
                    self.cityName = cityName
                    self.timeZone = json["timezone"].stringValue
                    
                    //    Second_Sub_View
                    self.humidity = round(json["currently"]["humidity"].double! * 100 * 10) / 10
                    self.windSpeed = round(json["currently"]["windSpeed"].double! * 100) / 100
                    self.visibility = round(json["currently"]["visibility"].double! * 100) / 100
                    self.pressure = round(json["currently"]["pressure"].double! * 10) / 10
                    
                    //    Third_Sub_View
                    let dailyArray = json["daily"]["data"].arrayValue
                    for index in 0..<dailyArray.count {
                        self.dateArray.append(self.convertUnixDateToDate(unixDate: dailyArray[index]["time"].double!, timeZone: self.timeZone))
                        self.dateIconArray.append(self.convertIconName(iconName: dailyArray[index]["icon"].stringValue))
                        self.sunriseTimeArray.append(self.convertUnixDateToTime(unixDate: dailyArray[index]["sunriseTime"].double!, timeZone: self.timeZone))
                        self.sunsetTimeArray.append(self.convertUnixDateToTime(unixDate: dailyArray[index]["sunsetTime"].double!, timeZone: self.timeZone))
                    }
                    
                    //---------------------------Today_Page--------------------------
                    //    Arround_Card
                    self.todayWindSpeed = round(json["currently"]["windSpeed"].double! * 100) / 100
                    self.todayPressure = round(json["currently"]["pressure"].double! * 10) / 10
                    self.todayPrecipitation = round(json["currently"]["precipIntensity"].double! * 10) / 10
                    self.todayTemperature = Int(round(json["currently"]["temperature"].double!))
                    self.todayHumidity = round(json["currently"]["humidity"].double! * 100 * 10) / 10
                    self.todayVisibility = round(json["currently"]["visibility"].double! * 100) / 100
                    self.todayCloudCover = round(json["currently"]["cloudCover"].double! * 100 * 100) / 100
                    self.todayOzone = round(json["currently"]["ozone"].double! * 10) / 10
                    
                    //    Center_Card
                    self.todayIcon = self.convertIconName(iconName: json["currently"]["icon"].stringValue)
                    self.todaySummary = json["currently"]["summary"].stringValue
                    
                    //---------------------------Weekyly_Page--------------------------
                    //    Top_Card
                    self.weeklyIcon = self.convertIconName(iconName: json["daily"]["icon"].stringValue)
                    self.weeklySummary = json["daily"]["summary"].stringValue
                    
                    //    Bottom_Figure
                    for index in 0..<dailyArray.count {
                        self.temperatureMinArray.append(Int(round(dailyArray[index]["temperatureLow"].double!)))
                        self.temperatureMaxArray.append(Int(round(dailyArray[index]["temperatureHigh"].double!)))
                    }
                    completed()
                }
            })
        }
    }
    
    func convertIconName(iconName: String) -> String {
        switch iconName {
        case "clear-day":
            return "weather-sunny"
        case "clear-night":
            return "weather-night"
        case "rain":
            return "weather-rainy"
        case "snow":
            return "weather-snowy"
        case "sleet":
            return "weather-snowy-rainy"
        case "wind":
            return "weather-windy-variant"
        case "fog":
            return "weather-fog"
        case "cloudy":
            return "weather-cloudy"
        case "partly-cloudy-night":
            return "weather-night-partly-cloudy"
        case "partly-cloudy-day":
            return "weather-partly-cloudy"
        default:
            return "weather-sunny"
        }
    }
    
    func convertUnixDateToDate(unixDate: Double, timeZone: String) -> String {
        let date = Date(timeIntervalSince1970: unixDate)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.string(from: date)
    }
    
    func convertUnixDateToTime(unixDate: Double, timeZone: String) -> String {
        let date = Date(timeIntervalSince1970: unixDate)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
}
