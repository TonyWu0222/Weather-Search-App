//
//  SearchTableViewCell.swift
//  iosApp
//
//  Created by Tony Wu on 11/24/19.
//  Copyright © 2019 Tony Wu. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var searchResultText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
