//
//  ViewController.swift
//  SoMovie
//
//  Created by Faith Cox on 10/10/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var movies : [Movie]!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var params = [
            "limit" : "2",
            "country" : "us"
        ]
        RottenClient.sharedInstance.getMovies(params, completion: { (movies, error) -> () in
            if (movies != nil) {
                println("\(movies!.count) movies")
            } else {
                println("no movies")
            }
            self.movies = movies
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

