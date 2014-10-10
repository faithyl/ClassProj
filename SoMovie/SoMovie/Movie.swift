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
    var runtime : Int
    var posters : [String:String]
    //var abridgedCast : [NSDictionary]
    var ratings : NSDictionary
    var ratingAudienceScore : Int = 0
    var ratingCriticsScore : Int = 0
    var releaseDates : [String:String]
    var theatreReleaseDate : String
    var links : [String:String]
    
    init(dictionary: NSDictionary) {
        id = dictionary["id"] as String
        title = dictionary["title"] as String
        year = dictionary["year"] as Int
        synopsis = dictionary["synopsis"] as String
        runtime = dictionary["runtime"] as Int
        posters = dictionary["posters"] as [String:String]
        //abridgedCast = dictionary["abrideged_cast"] as [NSDictionary]
        ratings = dictionary["ratings"] as NSDictionary
        ratingAudienceScore = ratings["audience_score"] as Int
        ratingCriticsScore = ratings["critics_score"] as Int
        releaseDates = dictionary["release_dates"] as [String:String]
        theatreReleaseDate = releaseDates["theater"]! as String
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
