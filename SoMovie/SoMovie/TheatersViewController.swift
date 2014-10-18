//
//  TheatersViewController.swift
//  SoMovie
//
//  Created by Faith Cox on 10/16/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

import UIKit

class TheatersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl:UIRefreshControl!
    var searchBar: UISearchBar!
    
    var theaters: [Theater]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 58
        tableView.rowHeight = UITableViewAutomaticDimension
        
        searchBar = UISearchBar()
        searchBar.delegate = self
        navigationItem.titleView = searchBar

        searchBar.becomeFirstResponder()

        // Do any additional setup after loading the view.
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refersh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshControl)
        
        self.refresh(self)
        

    }
    
    func refresh(sender:AnyObject)
    {
        var params = [
            "zip" : "95054",
            "radius" : "10",
            "numTheatres" : "20"
        ]
        
        TheaterClient.sharedInstance.getTheaters(params, completion: { (theaters, error) -> () in
            if (error != nil) {
                //self.errmsgView.hidden = false
            } else {
                if (theaters != nil) {
                    println("\(theaters!.count) theaters")
                } else {
                    println("no theaters")
                }
                self.theaters = theaters
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
        return self.theaters?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //println("I'm at row: \(indexPath.row), section: \(indexPath.section)")
        
        var cell = tableView.dequeueReusableCellWithIdentifier("TheaterCell") as TheaterCell
        
        var theater = self.theaters?[indexPath.row]
        cell.theater = theater
        return cell
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "theaterstSegue" {
            var indexPath = tableView.indexPathForSelectedRow()
            var theater = self.theaters![indexPath!.row]
            var svc = segue.destinationViewController as TheaterShowtimesViewController
            svc.theater = self.theaters![indexPath!.row]        }
    }

}
