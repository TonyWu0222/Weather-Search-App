//
//  CurrentLocation.swift
//  iosApp
//
//  Created by Tony Wu on 11/22/19.
//  Copyright © 2019 Tony Wu. All rights reserved.
//

import Foundation
import CoreLocation

class CurrentLocation: NSObject, CLLocationManagerDelegate {

    let locationManager: CLLocationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    var placemark: CLPlacemark?
    
    var latitude: Double! = nil
    var longitude: Double! = nil
    var cityName: String = ""
    
    typealias Complete = () -> ()

    func getCurrentLocation() {
        locationManager.delegate = self
        locationAuthCheck()
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func getCurrentCityName(completed: @escaping Complete) {
        geocoder.reverseGeocodeLocation(locationManager.location!, completionHandler: { placemarks, error in
            if error == nil, let placemarks = placemarks, !placemarks.isEmpty {
                self.placemark = placemarks.last!
                self.cityName = (self.placemark?.locality)!
                completed()
            }
        })
    }

    func locationAuthCheck() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            self.latitude = locationManager.location?.coordinate.latitude
            self.longitude = locationManager.location?.coordinate.longitude
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationAuthCheck()
        }
    }
}
