//
//  ShowtimeCell.swift
//  SoMovie
//
//  Created by Faith Cox on 10/18/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

import UIKit

class ShowtimeCell: UITableViewCell {

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var movietitleLabel: UILabel!
    
    var showtimeSegment: UISegmentedControl!
    
    var showtime : Showtime! {
        willSet(theater) {

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
