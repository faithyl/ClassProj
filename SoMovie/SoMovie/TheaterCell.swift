//
//  TheaterCell.swift
//  SoMovie
//
//  Created by Faith Cox on 10/16/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

import UIKit

class TheaterCell: UITableViewCell {

    @IBOutlet weak var theaternameLabel: UILabel!
    @IBOutlet weak var address1Label: UILabel!
    @IBOutlet weak var address2Label: UILabel!
    @IBOutlet weak var distLabel: UILabel!
    
    var theater : Theater! {
        willSet(theater) {
            theaternameLabel.text = theater?.name
            address1Label.text = theater?.street
            address2Label.text = theater!.city + ", " + theater!.state + " " + theater!.postalCode
            distLabel.text = NSString(format: "%.1f", theater!.distance) + "mi"
        }
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
