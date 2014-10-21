//
//  TheaterShowtimesViewController.swift
//  SoMovie
//
//  Created by Faith Cox on 10/18/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

import UIKit

class TheaterShowtimesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var theaternameLabel: UILabel!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    var theater: Theater!
    var movies : [Movie]?
    var showtimes: [Showtime]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.theaternameLabel.text = theater?.name
        self.streetLabel.text = theater?.street
        self.addressLabel.text = theater!.city + ", " + theater!.state + " " + theater!.postalCode
        self.phoneLabel.text = theater?.telephone
        
        self.refresh(self)
        // Do any additional setup after loading the view.
    }
    
    func refresh(sender:AnyObject)
    {
        var tId = theater?.id
        
        var todaysDate:NSDate = NSDate()
        var dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var DateInFormat:String = dateFormatter.stringFromDate(todaysDate)
        
        var params = [
            "theaterId" : tId!,
            "startDate" : DateInFormat,
            "numDays" : "1"
        ]
        
        TheaterClient.sharedInstance.getTheaterShowtimes(params, completion: { (movies, error) -> () in
            if (error != nil) {
                //self.errmsgView.hidden = false
            } else {
                if (movies != nil) {
                    //println("\(theater!.count) theater showtimes")
                } else {
                    //println("no theater showtimes")
                }
                
                self.movies = movies
                
                self.tableView.reloadData()
            }
        })
        
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //println("I'm at row: \(indexPath.row), section: \(indexPath.section)")
        
        var cell = tableView.dequeueReusableCellWithIdentifier("ShowtimeCell") as ShowtimeCell
        
        var movie = self.movies?[indexPath.row]
        
        cell.showtime = movie
        
        return cell
        
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
