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
    var abridged_cast : [String] = []
    var ratings : NSDictionary
    var audience_score : Int = 0
    var critics_score : Int = 0
    var release_dates : [String:String]
    var theatre_release_date : String
    var links : [String:String]
    var studio : String
    var genres : [String]
    var abridged_directors : [String] = []
    
    init(dictionary: NSDictionary, isDetail: Bool = false) {
        //the data type of the movie id returned by movie.json is different from the one returned by box_office.json
        //using isDetail to help distinguish the two
        if isDetail {
            id = String(dictionary["id"] as Int)
        } else {
            id = dictionary["id"] as String
        }
        title = dictionary["title"] as String
        year = dictionary["year"] as Int
        synopsis = dictionary["synopsis"] as String
        mpaa_rating = dictionary["mpaa_rating"] as String
        runtime = dictionary["runtime"] as Int
        posters = dictionary["posters"] as [String:String]
        thumbnail = posters["thumbnail"]! as String
        if let cast = dictionary["abridged_cast"] as? [NSDictionary] {
            for actor in cast {
                abridged_cast.append(actor["name"] as String)
            }
        }
        ratings = dictionary["ratings"] as NSDictionary
        audience_score = ratings["audience_score"] as Int
        critics_score = ratings["critics_score"] as Int
        release_dates = (dictionary["release_dates"] as? [String:String]) ?? [String:String]()
        theatre_release_date = release_dates["theater"] ?? ""
        links = (dictionary["links"] as? [String:String]) ?? [String:String]()
        studio = (dictionary["studio"] as? String) ?? ""
        genres = (dictionary["genres"] as? [String]) ?? []
        if let directors = dictionary["abridged_directors"] as? [NSDictionary] {
            for director in directors {
                abridged_directors.append(director["name"] as String)
            }
        }
    }
    
    class func moviesWithArray(array: [NSDictionary], isDetail: Bool = false) -> [Movie] {
        var movies = [Movie]()
        for dictionary in array {
            movies.append(Movie(dictionary: dictionary, isDetail: isDetail))
        }
        return movies
    }
}
