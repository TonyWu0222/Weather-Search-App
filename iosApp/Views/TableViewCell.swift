//
//  TableViewCell.swift
//  iosApp
//
//  Created by Tony Wu on 11/20/19.
//  Copyright © 2019 Tony Wu. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var dailyDate: UILabel!
    @IBOutlet weak var dailyIcon: UIImageView!
    @IBOutlet weak var dailySunriseTime: UILabel!
    @IBOutlet weak var dailySunsetTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
