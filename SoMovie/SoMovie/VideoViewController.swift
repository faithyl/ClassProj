//
//  VideoViewController.swift
//  SoMovie
//
//  Created by Faith Cox on 10/21/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

import UIKit
import MediaPlayer

class VideoViewController: UIViewController {
    
    var moviePlayer : MPMoviePlayerController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var url:NSURL = NSURL(string: "http://www.totaleclips.com/Player/Bounce.aspx?eclipid=e133332&bitrateid=449&vendorid=2223&type=.mp4")
        
        moviePlayer = MPMoviePlayerController(contentURL: url)
        moviePlayer.view.frame = CGRect(x: 20, y: 100, width: 200, height: 150)
        self.view.addSubview(moviePlayer.view)
        moviePlayer.fullscreen = true
        moviePlayer.controlStyle = MPMovieControlStyle.Embedded
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
