//
//  MovieCell.swift
//  SoMovie
//
//  Created by Faith Cox on 10/10/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var movietitleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    
    var movie : Movie! {
        willSet(movie) {
            var posterURL = movie?
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
