//
//  FandangoClient.swift
//  SoMovie
//
//  Created by Faith Cox on 10/10/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

import UIKit

let theaterapiKey = "2dfgb8jeentbh2geqgwarjxf"
let theaterbaseUrl = NSURL(string: "http://data.tmsapi.com/v1/")

class TheaterClient: BDBOAuth1RequestOperationManager {
    
    class var sharedInstance : TheaterClient {
        struct  Static {
            static let instance = TheaterClient(baseURL: theaterbaseUrl, consumerKey: theaterapiKey, consumerSecret: nil)
        }
        return Static.instance
    }
    
    func getTheaters(params: [String: String], completion: (theaters: [Theater]?, error: NSError?) -> ()) {
        var parameters = params
        
        var theaterZip = parameters.removeValueForKey("zip") as String!
        parameters["api_key"] = theaterapiKey
        
        GET("theatres?zip=\(theaterZip)", parameters: parameters,
            success: { (operation:AFHTTPRequestOperation!, response:AnyObject!) -> Void in
                //println("get theaters: \(response)")
                var theaters = Theater.theatersWithArray(response as [NSDictionary])
                completion(theaters: theaters, error: nil)
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("error getting Theaters")
                completion(theaters: nil, error: error)
            }
        )
    }
    
    func getTheaterShowtimes(params: [String: String], completion: (movies: [Movie]?, error: NSError?) -> ()) {
        var parameters = params
        
        var theaterId = parameters.removeValueForKey("theaterId") as String!
        var startDate : String
        parameters["api_key"] = theaterapiKey
        
        if (parameters["startDate"] != nil){
            startDate = parameters["startDate"] as String!
        } else {
            var todaysDate:NSDate = NSDate()
            var dateFormatter:NSDateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            var DateInFormat:String = dateFormatter.stringFromDate(todaysDate)
            startDate = DateInFormat
        }

        GET("theatres/\(theaterId)/showings?startDate=\(startDate)", parameters: parameters,
            success: { (operation:AFHTTPRequestOperation!, response:AnyObject!) -> Void in
                println("theaters showtime: \(response)")
                var movies = Movie.moviesWithArray(response as [NSDictionary], isRotten: false)
                completion(movies: movies, error: nil)
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("error getting theater showtimes")
                completion(movies: nil, error: error)
            }
        )
    }

    func getMovies(params: [String: String], completion: (movies: [Movie]?, error: NSError?) -> ()) {
        var parameters = params;
        parameters["api_key"] = theaterapiKey
        GET("movies/showings", parameters: parameters,
            success: { (operation:AFHTTPRequestOperation!, response:AnyObject!) -> Void in
                //println("get movies: \(response)")
                var movies = Movie.moviesWithArray(response as [NSDictionary], isRotten: false)
                completion(movies: movies, error: nil)
            },
            failure: { (operation: AFHTTPRequestOperation!, error:NSError!) -> Void in
                println("error getting movies from TMS movie showings api")
                completion(movies: nil, error: error)
            }
        )
    }

    func searchPrograms(params: [String: String], completion: (movies: [Movie]?, error: NSError?) -> ()) {
        var parameters = params;
        parameters["queryFields"] = "title"
        parameters["titleLang"] = "en"
        parameters["descriptionLang"] = "en"
        parameters["entityType"] = "movie"
        parameters["limit"] = "20"
        parameters["api_key"] = theaterapiKey
        GET("programs/search", parameters: parameters,
            success: { (operation:AFHTTPRequestOperation!, response:AnyObject!) -> Void in
                //println("get movies: \(response)")
                var searchResult = response as NSDictionary
                var programList = searchResult["hits"] as [NSDictionary]
                var movies = Movie.programsWithArray(programList)
                completion(movies: movies, error: nil)
            },
            failure: { (operation: AFHTTPRequestOperation!, error:NSError!) -> Void in
                println("error getting movies from TMS program search api")
                completion(movies: nil, error: error)
            }
        )
    }
    
    func getScreenPlayTrailers(params: [String: String], completion: (trailers: [Trailer]?, error: NSError?) -> ()) {
        var parameters = params
        var rootId = parameters.removeValueForKey("rootId") as String!
        
        parameters["api_key"] = theaterapiKey
        
        GET("screenplayTrailers?rootids=\(rootId)" ,
            parameters: parameters,
            success: { (operation:AFHTTPRequestOperation!, response:AnyObject!) -> Void in
                //println("get Trailer: \(response)")
                let resp = response["response"] as NSDictionary
                var trailerlist = resp["trailers"] as [NSDictionary]
                var trailers = Trailer.trailerWithArray(trailerlist)
                completion(trailers: trailers, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("error getting trailers")
                //self.loginCompletion? (user: nil, error: error)
                completion(trailers: nil, error: error)
        })
    }

    func getMovieShowtimes(params: [String: String], completion: (movies: [Movie]?, error: NSError?) -> ()) {
        var parameters = params;
        var movieId = parameters.removeValueForKey("movieId") as String!
        parameters["api_key"] = theaterapiKey
        GET("movies/\(movieId)/showings", parameters: parameters,
            success: { (operation:AFHTTPRequestOperation!, response:AnyObject!) -> Void in
                //println("get movies: \(response)")
                var movies = Movie.moviesWithArray(response as [NSDictionary], isRotten: false)
                completion(movies: movies, error: nil)
            },
            failure: { (operation: AFHTTPRequestOperation!, error:NSError!) -> Void in
                println("error getting movies from TMS movie showtimes api")
                completion(movies: nil, error: error)
            }
        )
    }
}
