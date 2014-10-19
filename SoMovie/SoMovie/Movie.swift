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
    var abridged_cast : [[String:String]] = []
    var ratings : NSDictionary
    var audience_score : Int = 0
    var critics_score : Int = 0
    var release_dates : [String:String]
    var theatre_release_date : String
    var links : [String:String]
    var studio : String
    var genres : [String]
    var abridged_directors : [String] = []
    var showtimes : [Showtime] = []
    
    init(dictionary: NSDictionary, isDetail: Bool = false, isRotten: Bool = true ) {
        //the data type of the movie id returned by movie.json is different from the one returned by box_office.json
        //using isDetail to help distinguish the two
        title = dictionary["title"] as String
        if isRotten {
            if isDetail {
                id = String(dictionary["id"] as Int)
            } else {
                id = dictionary["id"] as String
            }
            year = (dictionary["year"] as? Int) ?? 0
            synopsis = dictionary["synopsis"] as String
            mpaa_rating = dictionary["mpaa_rating"] as String
            runtime = (dictionary["runtime"] as? Int) ?? 0
            posters = dictionary["posters"] as [String:String]
            thumbnail = posters["thumbnail"]! as String
            if let cast = dictionary["abridged_cast"] as? [NSDictionary] {
                for actor in cast {
                    var mapping = ["name" : actor["name"] as String]
                    if let characters = actor["characters"] as? [String] {
                        mapping["character"] = characters[0] as String
                    }
                    abridged_cast.append(mapping)
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
        } else {
            id = dictionary["rootId"] as String
            year = dictionary["releaseYear"] as Int
            synopsis = (dictionary["longDescription"] as? String) ?? ""
            if (dictionary["ratings"] != nil) {
                var mpaa_ratings = dictionary["ratings"] as [NSDictionary]
                var mpaa = mpaa_ratings[0] as [String:String]
                mpaa_rating = mpaa["code"] as String!
            } else {
                mpaa_rating = ""
            }
            runtime = 0
            posters = [String:String]()
            var posterInfo = dictionary["preferredImage"] as NSDictionary
            thumbnail = posterInfo["uri"] as String
            if let cast = dictionary["topCast"] as? [String] {
                for item in cast {
                    var mapping = ["name" : item as String]
                    mapping["character"] = ""
                    abridged_cast.append(mapping)
                }
            }
            ratings = [String:String]()
            audience_score = 0
            critics_score = 0
            release_dates = [String:String]()
            theatre_release_date = ""
            links = [String:String]()
            studio = ""
            genres = dictionary["genres"] as [String]
            ratings = [String:String]()
            showtimes = (Showtime.showtimesWithArray(dictionary["showtimes"] as [NSDictionary]))
        }
    }
    
    class func moviesWithArray(array: [NSDictionary], isDetail: Bool = false, isRotten: Bool = true) -> [Movie] {
        var movies = [Movie]()
        var yr : Int
        
        for dictionary in array {
            println(dictionary)
            if (isRotten == false) {
                yr = (dictionary["releaseYear"] as? Int) ?? 0
            } else {
                yr = (dictionary["year"] as? Int) ?? 0
            }
            if (yr >= 2014) {
                movies.append(Movie(dictionary: dictionary, isDetail: isDetail, isRotten: isRotten))
            }
        }
        return movies
    }
}
