//
//  MovieDetailViewController.swift
//  SoMovie
//
//  Created by Erin Chuang on 10/10/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

import UIKit
import CoreLocation
import MessageUI

class MovieDetailViewController: UIViewController, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning, DatePickerDelegate, LocationFilterDelegate, CLLocationManagerDelegate, MFMailComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    let app = UIApplication.sharedApplication().delegate as AppDelegate
    let locationManager = CLLocationManager()
    var movie : Movie!
    var rottenMovie : Movie?
    var showtimes : [Showtime]?
    var isPresenting : Bool!
    var queryDate: NSDate!
    var queryZip: String!
    var queryRadius: Int!
    var currentCoord: CLLocationCoordinate2D!

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var audienceScoreLabel: UILabel!
    @IBOutlet weak var criticsScoreLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var castLabel: UILabel!
    @IBOutlet weak var showtimeTableView: UITableView!
    @IBOutlet weak var showtimeErrMsg: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        app.email!.mailComposeDelegate = self
        //self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        showtimeTableView.dataSource = self
        showtimeTableView.delegate = self
        
        if let imgurl = self.movie?.thumbnail {
            self.posterImage.setImageWithURL(NSURL(string: imgurl))
        }
        self.titleLabel.text = "\(self.movie.title) (\(self.movie.year))"
        self.genresLabel.text = " - " + join(" | ", self.movie.genres)
        self.queryDate = NSDate()
        self.queryZip = ""
        self.queryRadius = 5
        self.setDateButtonTitle(self.queryDate)
        self.setLocationButtonTitle(self.queryZip)
        self.synopsisLabel.text = self.movie.synopsis
        self.synopsisLabel.sizeToFit()
        self.directorLabel.text = join(", ", self.movie.abridged_directors)
        self.showtimeErrMsg.hidden = false
        self.listCast()
        self.showtimes = self.movie.showtimes

        var params = ["q": self.movie.title, "page_limit": "10"]
        //directors are only available in the movie detail api, so need to call two rotten apis to get the data
        RottenClient.sharedInstance.searchWithParams(params, completion: { (movies, error) -> () in
            var rMovie = self.getMatchingMovieByTitle(movies!, title: self.movie.title) ?? nil
            if rMovie != nil {
                var movieId = rMovie!.id
                RottenClient.sharedInstance.getMovieDetail(movieId, completion: { (rottenMovie, error) -> () in
                    self.rottenMovie = rottenMovie
                    self.ratingLabel.text = self.rottenMovie!.mpaa_rating
                    self.runtimeLabel.text = "\(self.rottenMovie!.runtime) min"
                    self.audienceScoreLabel.text = String(self.rottenMovie!.audience_score)
                    self.criticsScoreLabel.text = String(self.rottenMovie!.critics_score)
                    self.directorLabel.text = join(", ", self.rottenMovie!.abridged_directors)
                })
            }
            self.recalcScrollViewSize()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func recalcScrollViewSize() -> Void {
        var castLabelHeight = self.castLabel.hidden ? 0 : self.castLabel.frame.height
        self.containerView.frame.size.height = self.titleLabel.frame.height + self.synopsisLabel.frame.height + castLabelHeight + 180;
        var scrollViewHeight = self.containerView.frame.height + self.containerView.frame.origin.y
        self.scrollView.contentSize = CGSize(width:self.view.frame.width, height: scrollViewHeight)
    }
    
    func listCast() -> Void {
        self.castLabel.text = ""
        for actor in self.movie.abridged_cast {
            if (self.castLabel.text != "") {
                self.castLabel.text = self.castLabel.text! + "\n"
            }
            var actorName = actor["name"]! as String
            self.castLabel.text = self.castLabel.text! + "\(actorName)"
        }
        self.castLabel.sizeToFit()
    }
    
    func getMatchingMovieByTitle(movies: [Movie], title: String) -> Movie? {
        for movie in movies {
            if movie.title == title {
                return movie
            }
        }
        return nil
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return (self.showtimes != nil) ? self.showtimes!.count : 0
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("RestroCell") as MovieCell
        return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        var vc = segue.destinationViewController as UIViewController
        vc.modalPresentationStyle = UIModalPresentationStyle.Custom
        vc.transitioningDelegate = self
        if segue.identifier == "datePickerSegue" {
            var dvc = vc as DatePickerViewController
            dvc.delegate = self
        } else if segue.identifier == "locationFilterSegue" {
            var dvc = vc as LocationFilterViewController
            dvc.delegate = self
        }
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.isPresenting = true
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.isPresenting = false
        return self
    }
    /*
    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
    }
    
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    }
    */
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.5
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        var containerView = transitionContext.containerView()
        var toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as UIViewController!
        var fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as UIViewController!
        if isPresenting! {
            containerView.addSubview(toViewController.view)
            toViewController.view.frame.origin.y = self.view.frame.height
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                var diffHeight : CGFloat = (toViewController.isMemberOfClass(DatePickerViewController)) ? 200 : 310
                toViewController.view.frame.origin.y = self.view.frame.height - diffHeight
                }) { (finished : Bool) -> Void in
                transitionContext.completeTransition(true)
            }
        } else {
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                fromViewController.view.frame.origin.y = self.view.frame.height
                }) { (finished : Bool) -> Void in
                transitionContext.completeTransition(true)
                fromViewController.view.removeFromSuperview()
            }
        }
    }
    
    func setDateButtonTitle(date: NSDate) {
        var formatter = NSDateFormatter()
        formatter.dateFormat = "M/d/yyyy"
        //formatter.dateFormat = "yyyy-mm-dd"
        self.dateButton.setTitle(formatter.stringFromDate(date),forState: UIControlState.Normal)
    }
    
    func setLocationButtonTitle(zipCode: String) {
        if zipCode == "" {
            locationButton.setTitle("Current Location", forState: UIControlState.Normal)
        } else {
            locationButton.setTitle("ZIP " + zipCode, forState: UIControlState.Normal)
        }
    }
    
    func dateSelected(date: NSDate) {
        self.queryDate = date
        setDateButtonTitle(date)
        updateShowtimes()
    }
    
    func locationFilterSet(zipCode: String, radius: Int) {
        self.queryZip = zipCode
        self.queryRadius = radius
        setLocationButtonTitle(zipCode)
        updateShowtimes()
    }
    
    func updateShowtimes() {
        var formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        var params : [String:String] = [
            "startDate" : formatter.stringFromDate(self.queryDate),
            "radius" : String(self.queryRadius)
        ]
        if self.queryZip != "" {
            params["zip"] = self.queryZip
        } else {
            let nf = NSNumberFormatter()
            nf.numberStyle = .DecimalStyle
            params["lat"] = nf.stringFromNumber(self.currentCoord.latitude)
            params["lng"] = nf.stringFromNumber(self.currentCoord.longitude)
        }
    }
    
    @IBAction func invokeEmail(sender: UIButton) {
        if MFMailComposeViewController.canSendMail() {
            var movieInfo : [String] = []
            movieInfo.append("Title:\ttitle")
            movieInfo.append("Runtime:\truntime min")
            movieInfo.append("Theater:\ttheatre")
            movieInfo.append("Showtime:\tshowtime")
            movieInfo.append("Theater Address:\ttheater address")
            movieInfo.append("Synopsis:\nsysnopsis")
            var movieInfoString = join("\n", movieInfo)
            app.email!.setSubject("Movie Invitation - title")
            app.email!.setMessageBody("test", isHTML: false)
            self.presentViewController(app.email!, animated: true, completion: nil)
        } else {
            var alert = UIAlertController(title: "Alert", message: "Your device cannot send emails", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        self.currentCoord = manager.location.coordinate
        println("locations = \(self.currentCoord.latitude) \(self.currentCoord.longitude)")
    }
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}