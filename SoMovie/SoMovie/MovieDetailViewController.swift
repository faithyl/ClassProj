//
//  MovieDetailViewController.swift
//  SoMovie
//
//  Created by Erin Chuang on 10/10/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    var movieId : String!
    var movie : Movie!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        RottenClient.sharedInstance.getMovieDetail(movieId, completion: { (movie, error) -> () in
            if (movie != nil) {
                println("movie info retrieved")
            } else {
                println("no movie info")
            }
            //self.movie = movie
            println(movie)
        })
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
