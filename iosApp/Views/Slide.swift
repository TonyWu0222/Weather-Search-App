//
//  Slide.swift
//  iosApp
//
//  Created by Tony Wu on 11/19/19.
//  Copyright © 2019 Tony Wu. All rights reserved.
//

import UIKit

class Slide: UIView {
    
    //-----------------Favorite_Button-------------------
    @IBOutlet weak var favoriteButton: UIButton!
    
    //--------------------Top_Card-----------------------
    @IBOutlet weak var weatherCard: UIView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var summary: UILabel!
    @IBOutlet weak var city: UILabel!
    
    //-------------------Middle_Icon---------------------
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var visibility: UILabel!
    @IBOutlet weak var pressure: UILabel!
    
    //-------------------Bottom_Table--------------------
    @IBOutlet weak var weatherTable: UITableView!
    
}
