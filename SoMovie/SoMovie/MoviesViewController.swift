//
//  ViewController.swift
//  SoMovie
//
//  Created by Faith Cox on 10/10/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

import UIKit
import CoreLocation

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate  {
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl:UIRefreshControl!
    var searchBar: UISearchBar!
    
    var movies : [Movie]?
    var currentCoord : CLLocationCoordinate2D!

    override func viewDidLoad() {
        super.viewDidLoad()

        //self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }

        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.estimatedRowHeight = 77
        tableView.rowHeight = UITableViewAutomaticDimension
        
        searchBar = UISearchBar()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refersh")
        self.refreshControl.addTarget(self, action: "refreshTMS:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshControl)
        
        self.refreshTMS(self)
        
        searchBar.becomeFirstResponder()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func refresh(sender:AnyObject)
    {
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
    
    func refreshTMS(sender:AnyObject)
    {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        var params : [String:String] = [
            "startDate" : formatter.stringFromDate(NSDate()),
            "radius" : "10"
        ]
        let nf = NSNumberFormatter()
        nf.numberStyle = .DecimalStyle
        //default: san francisco
        let coord = (self.currentCoord != nil) ? self.currentCoord : CLLocationCoordinate2DMake(37.7833, -122.4167)
        params["lat"] = nf.stringFromNumber(coord.latitude)
        params["lng"] = nf.stringFromNumber(coord.longitude)
        TheaterClient.sharedInstance.getMovies(params, completion: { (movies, error) -> () in
            if error != nil {
                println("failed to bind movies")
            } else {
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
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        doSearch(["q": searchBar.text])
        searchBar.endEditing(true)
    }
        
    func doSearch(params: [String: String]) {
        let searchText = params["q"]
        if (searchText != nil && !searchText!.isEmpty) {
            TheaterClient.sharedInstance.searchPrograms(params, completion: { (movies, error) -> () in
                self.movies = movies
                self.tableView.reloadData()
            })
        } else {
            println("default query")
            refreshTMS(self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "movieDetailSegue" {
            var indexPath = tableView.indexPathForSelectedRow()
            var svc = segue.destinationViewController as MovieDetailViewController
            svc.movie = self.movies![indexPath!.row]
        } else if (segue.identifier == "theatersSegue") {
            var svc = segue.destinationViewController as TheatersViewController
        }
    }

    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        self.currentCoord = manager.location.coordinate
        println("locations = \(self.currentCoord.latitude) \(self.currentCoord.longitude)")
    }
}

