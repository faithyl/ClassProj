//
//  TheaterShowtimeCell.swift
//  SoMovie
//
//  Created by Erin Chuang on 10/22/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

import UIKit

class TheaterShowtimeCell: UITableViewCell {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var segmentedCtrl: UISegmentedControl!
    
    var showtimes : [String]! {
        willSet(list) {
            var index : Int = 0
            var existingCount : Int = segmentedCtrl.numberOfSegments
            for item in list {
                if index >= existingCount {
                    segmentedCtrl.insertSegmentWithTitle(item, atIndex: index, animated: true)
                } else {
                    segmentedCtrl.setTitle(item, forSegmentAtIndex: index)
                }
                index += 1
            }
            if list.count < existingCount {
                var startIndex = existingCount - 1
                var endIndex = list.count - 1
                for var idx = startIndex; idx > endIndex; idx = idx - 1 {
                    segmentedCtrl.removeSegmentAtIndex(idx, animated: false)
                }
            }
            scrollView.contentSize.width = segmentedCtrl.frame.width
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
