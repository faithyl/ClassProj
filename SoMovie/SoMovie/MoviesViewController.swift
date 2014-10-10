//
//  ViewController.swift
//  SoMovie
//
//  Created by Faith Cox on 10/10/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate  {
    
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
        
        searchBar = UISearchBar()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refersh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshControl)
        
        self.refresh(self)
        
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
        doSearch(["q": searchBar.text, "page_limit": "20"])
        searchBar.endEditing(true)
    }
    
    func doSearch(params: [String: String]) {
        let searchText = params["q"]
        if (searchText != nil && !searchText!.isEmpty) {
            RottenClient.sharedInstance.searchWithParams(params, completion: { (movies, error) -> () in
                self.movies = movies
                self.tableView.reloadData()
            })
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "movieDetailSegue" {
            var indexPath = tableView.indexPathForSelectedRow()
            var movie = self.movies![indexPath!.row]
            var svc = segue.destinationViewController as MovieDetailViewController
            svc.movieId = movie.id
        }
    }
}

