//
//  MovieDetailViewController.swift
//  SoMovie
//
//  Created by Erin Chuang on 10/10/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning, DatePickerDelegate {
    var movieId : String!
    var movie : Movie!
    var isPresenting : Bool!

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        RottenClient.sharedInstance.getMovieDetail(movieId, completion: { (movie, error) -> () in
            if (movie != nil) {
                println("movie info retrieved")
            } else {
                println("no movie info")
            }
            self.movie = movie
            if let imgurl = self.movie?.thumbnail {
                self.posterImage.setImageWithURL(NSURL(string: imgurl))
            }
            self.titleLabel.text = "\(self.movie.title) (\(self.movie.year))"
            self.ratingLabel.text = self.movie.mpaa_rating
            self.runtimeLabel.text = "\(self.movie.runtime) min"
            self.genresLabel.text = " - " + join(" | ", self.movie.genres)
            self.setDateButtonTitle(NSDate())
            self.synopsisLabel.text = self.movie.synopsis
            self.synopsisLabel.sizeToFit()
            self.audienceScoreLabel.text = String(self.movie.audience_score)
            self.criticsScoreLabel.text = String(self.movie.critics_score)
            self.directorLabel.text = join(", ", self.movie.abridged_directors)
            self.castLabel.text = join("\n", self.movie.abridged_cast)
            self.castLabel.hidden = true
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
    
    @IBAction func onCastToggle(sender: UIButton) {
        self.castLabel.hidden = !self.castLabel.hidden
        var title = self.castLabel.hidden ? ">" : "v"
        sender.setTitle(title, forState: UIControlState.Normal)
        self.recalcScrollViewSize()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        var vc = segue.destinationViewController as UIViewController
        vc.modalPresentationStyle = UIModalPresentationStyle.Custom
        vc.transitioningDelegate = self
        var dvc = vc as DatePickerViewController
        dvc.delegate = self
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
        return 1
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        var containerView = transitionContext.containerView()
        var toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as UIViewController!
        var fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as UIViewController!
        if isPresenting! {
            containerView.addSubview(toViewController.view)
            toViewController.view.frame.origin.y = self.view.frame.height
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                toViewController.view.frame.origin.y = self.view.frame.height - 200
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
        self.dateButton.setTitle(formatter.stringFromDate(date),forState: UIControlState.Normal)
    }
    
    func dateSelected(date: NSDate) {
        setDateButtonTitle(date)
    }
}
