//
//  VideoViewController.swift
//  SoMovie
//
//  Created by Faith Cox on 10/21/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

import UIKit
import MediaPlayer

class VideoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var moviePlayer : MPMoviePlayerController!
    
    var trailers : [Trailer]?
    var rootId : String!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view.
        
        self.refresh(self)
    }
    
    func refresh(sender:AnyObject)
    {
        //rootId = "10233171" as String
        var params = [
            "rootId" : rootId!,
            "bitrateids" : "449",
            "languageid" : "52"
        ]
        
        TheaterClient.sharedInstance.getScreenPlayTrailers(params, completion: { (trailers, error) -> () in
            if (error != nil) {
                //self.errmsgView.hidden = false
            } else {
                if (trailers != nil) {
                    println("\(trailers!.count) trailer")
                    
                    self.trailers = trailers
                    
                    //println(self.trailers?.first?.url)
                    var urlStr = self.trailers?.first?.url as String!
                    var url:NSURL = NSURL(string: urlStr)
                    self.moviePlayer = MPMoviePlayerController(contentURL: url)
                    self.moviePlayer.view.frame = CGRect(x: 10, y: 70, width: 300, height: 150)
                    self.view.addSubview(self.moviePlayer.view)
                    self.moviePlayer.fullscreen = false
                    self.moviePlayer.controlStyle = MPMovieControlStyle.Embedded
                    
                    let desc = self.trailers?.first?.trailerDesc as String!
                    var trDesc = (desc as NSString).substringFromIndex(1)
                    var strCount = countElements(trDesc)
                    self.titleLabel.text = (trDesc as NSString).substringToIndex(strCount-1)
                    
                    self.tableView.reloadData()

                } else {
                    //println("no theater showtimes")
                }
            }
        })
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.trailers?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //println("I'm at row: \(indexPath.row), section: \(indexPath.section)")
        
        var cell = tableView.dequeueReusableCellWithIdentifier("TrailerCell") as TrailerCell
        
        var trailer = self.trailers?[indexPath.row]
        
        cell.trailer = trailer
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var trailerURL = self.trailers?[indexPath.row].url as String!
        println(trailerURL)
        var url:NSURL = NSURL(string: trailerURL)
        self.moviePlayer = MPMoviePlayerController(contentURL: url)
        self.moviePlayer.view.frame = CGRect(x: 10, y: 70, width: 300, height: 150)
        self.view.addSubview(self.moviePlayer.view)

        self.moviePlayer.fullscreen = false
        self.moviePlayer.controlStyle = MPMovieControlStyle.Embedded
        
        let desc = self.trailers?[indexPath.row].trailerDesc as String!
        var trDesc = (desc as NSString).substringFromIndex(1)
        var strCount = countElements(trDesc)
        self.titleLabel.text = (trDesc as NSString).substringToIndex(strCount-1)
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
