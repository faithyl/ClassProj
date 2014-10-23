//
//  TrailerCell.swift
//  SoMovie
//
//  Created by Faith Cox on 10/22/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

import UIKit
import AVFoundation


class TrailerCell: UITableViewCell {

    @IBOutlet weak var trailercapLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var thumnailImage: UIImageView!
    
    var trailer : Trailer! {
        
        willSet(trailer) {
            //println(trailer.trailerDesc)
            let desc = trailer.trailerDesc as String
            var trDesc = (desc as NSString).substringFromIndex(1)
            var strCount = countElements(trDesc)
            
            trailercapLabel.text = (trDesc as NSString).substringToIndex(strCount-1)
            
            var rt = trailer.runtime as Int!
            if (rt >= 60 ) {
                var rtMin = trailer.runtime/60
                var rtSec = rt - (rtMin * 60)
                runtimeLabel.text = String(rtMin) + ":" + String(rtSec)
            } else {
                runtimeLabel.text = "0:" + String(rt)
            }
            
            var urlStr = trailer.url as String!
            var url:NSURL = NSURL(string: urlStr)
            var asst : AVURLAsset = AVURLAsset(URL: url, options: nil)
            var gen : AVAssetImageGenerator = AVAssetImageGenerator(asset: asst)
            gen.appliesPreferredTrackTransform = true
            let  time : CMTime = CMTimeMakeWithSeconds(10.0, 600)
            var error : NSErrorPointer = nil
            var actTime : UnsafeMutablePointer<CMTime> = nil
            var img : CGImage = gen.copyCGImageAtTime(time, actualTime: actTime, error: error)
            var thum : UIImage = UIImage(CGImage: img)
            thumnailImage.image = UIImage(CGImage: img)
            
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
