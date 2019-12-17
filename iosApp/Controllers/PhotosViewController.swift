//
//  PhotosViewController.swift
//  iosApp
//
//  Created by Tony Wu on 11/23/19.
//  Copyright © 2019 Tony Wu. All rights reserved.
//

import UIKit
import SwiftSpinner

class PhotosViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    var currentWeather: CurrentWeather? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        SwiftSpinner.show("Fetching Google Images...")
        
        let tabController = tabBarController as! TabBarController
        currentWeather = tabController.currentWeather
        let cityPhotos: CityPhotos = CityPhotos()
        cityPhotos.downloadCityPhotos(cityName: (currentWeather?.cityName.replacingOccurrences(of: " ", with: "%20"))!, completed: {
            self.loadPhotos(cityPhotoUrlArray: cityPhotos.cityPhotoUrlArray)
            SwiftSpinner.hide()
        })
    }
    
    func loadPhotos(cityPhotoUrlArray: [String?]) {
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: scrollView.frame.size.height * CGFloat(cityPhotoUrlArray.count * 3 / 4))
        for index in 0..<cityPhotoUrlArray.count {
            let cityImage = UIImageView()
            let url = URL(string: (cityPhotoUrlArray[index])!)
//            let url = URL(string: "https://upload.wikimedia.org/wikipedia/commons/d/df/Pudong_Shanghai_November_2017_panorama.jpg")
//            print(url)
            
            let data = try? Data(contentsOf: url!)
            cityImage.image = UIImage(data: data!)
            
            scrollView.addSubview(cityImage)
            
            cityImage.frame.size = CGSize(width: scrollView.frame.size.width, height: scrollView.frame.size.height * 3 / 4)
            cityImage.frame.origin.y = (scrollView.frame.size.height * 3 / 4) * CGFloat(index)
        }
    }

}

