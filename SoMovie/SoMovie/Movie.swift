//
//  Movie.swift
//  SoMovie
//
//  Created by Erin Chuang on 10/10/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

import UIKit

class Movie: NSObject {
    var id : String
    var title : String
    var year : Int
    var synopsis : String
    var mpaa_rating : String
    var runtime : Int
    var posters : [String:String]
    var thumbnail : String
    //var abridgedCast : [NSDictionary]
    var ratings : NSDictionary
    var audience_score : Int = 0
    var critics_score : Int = 0
    var release_dates : [String:String]
    var theatre_release_date : String
    var links : [String:String]
    
    init(dictionary: NSDictionary) {
        id = dictionary["id"] as String
        title = dictionary["title"] as String
        year = dictionary["year"] as Int
        synopsis = dictionary["synopsis"] as String
        mpaa_rating = dictionary["mpaa_rating"] as String
        runtime = dictionary["runtime"] as Int
        posters = dictionary["posters"] as [String:String]
        thumbnail = posters["thumbnail"]! as String
        //abridgedCast = dictionary["abrideged_cast"] as [NSDictionary]
        ratings = dictionary["ratings"] as NSDictionary
        audience_score = ratings["audience_score"] as Int
        critics_score = ratings["critics_score"] as Int
        release_dates = dictionary["release_dates"] as [String:String]
        theatre_release_date = release_dates["theater"]! as String
        links = dictionary["links"] as [String:String]
    }
    
    class func moviesWithArray(array: [NSDictionary]) -> [Movie] {
        var movies = [Movie]()
        for dictionary in array {
            movies.append(Movie(dictionary: dictionary))
        }
        return movies
    }
}
