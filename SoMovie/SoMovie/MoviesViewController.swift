//
//  ViewController.swift
//  SoMovie
//
//  Created by Faith Cox on 10/10/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl:UIRefreshControl!
    var searchBar: UISearchBar!
    
    var movies : [Movie]?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.estimatedRowHeight = 77
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refersh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshControl)
        
        self.refresh(self)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func refresh(sender:AnyObject)
    {
        /*
        var url = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=dagqdghwaq3e3mxyrp7kmmj5&limit=20&country=us"
        
        var request = NSURLRequest (URL: NSURL(string: url))
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if (error != nil) {
                //self.errmsgView.hidden = false
            } else {
                var object = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
                
                self.movies = object["movies"] as [NSDictionary]
                
                self.tableView.reloadData()
                //self.errmsgView.hidden = true
            }
            self.refreshControl.endRefreshing()
            
        }
        */
        var params = [
            "limit" : "20",
            "country" : "us"
        ]
        
        RottenClient.sharedInstance.getMovies(params, completion: { (movies, error) -> () in
            if (error != nil) {
                //self.errmsgView.hidden = false
            } else {
                if (movies != nil) {
                    println("\(movies!.count) movies")
                } else {
                    println("no movies")
                }
                self.movies = movies
                self.tableView.reloadData()
            }
            self.refreshControl.endRefreshing()
        })

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //println("I'm at row: \(indexPath.row), section: \(indexPath.section)")
        
        var cell = tableView.dequeueReusableCellWithIdentifier("MovieCell") as MovieCell
        
        var movie = self.movies?[indexPath.row]
        cell.movie = movie
        return cell
        
    }

}

