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
    @IBOutlet weak var showtimeSegment: UISegmentedControl!
    @IBOutlet weak var stscrollView: UIScrollView!
    
    var showtime : Movie! {
        
        //showtimeSegment2.frame = CGRectMake(63, 50, 113, 21)
            
        willSet(movie) {
            var posterURL = movie?.thumbnail as String!
            posterImage.setImageWithURL(NSURL(string: posterURL))
            movietitleLabel.text = movie?.title
            var showtimes = movie.showtimes as [Showtime]!
            println(showtimes)
            var iCount : Int = 0
            for item in showtimes {
                let st = item as Showtime!
                var time = st.dateTime as String!
                if (iCount >= 2) {
                    showtimeSegment.insertSegmentWithTitle(time, atIndex: iCount, animated: true)
                } else {
                    showtimeSegment.setTitle(time, forSegmentAtIndex: iCount)
                }
                iCount += 1
            }
            showtimeSegment.selectedSegmentIndex = 0
            if (showtimes.count < 2) {
                showtimeSegment.removeSegmentAtIndex(1, animated: false)
            }
            stscrollView.contentSize.width = showtimeSegment.frame.width
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
