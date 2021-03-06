//
//  RottenClient.swift
//  SoMovie
//
//  Created by Faith Cox on 10/10/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

import UIKit

let apiKey = "2fjwqkw6eygb8p26ua6sbevb"
let baseUrl = NSURL(string: "http://api.rottentomatoes.com/api/public/v1.0/")

class RottenClient: BDBOAuth1RequestOperationManager {
    class var sharedInstance : RottenClient {
        struct Static {
            static let instance = RottenClient(baseURL: baseUrl, consumerKey: apiKey, consumerSecret: nil)
        }
        return Static.instance
    }
    
    func getMovies(params: [String: String], completion: (movies: [Movie]?, error: NSError?) -> ()) {
        var parameters = params;
        parameters["apikey"] = apiKey
        GET("lists/movies/opening.json", parameters: parameters,
            success: { (operation:AFHTTPRequestOperation!, response:AnyObject!) -> Void in
                //println("get movies: \(response)")
                let movieList = response["movies"] as [NSDictionary]
                var movies = Movie.moviesWithArray(movieList)
                completion(movies: movies, error: nil)
            },
            failure: { (operation: AFHTTPRequestOperation!, error:NSError!) -> Void in
                println("error getting movies from Rotten Tomatoes")
                completion(movies: nil, error: error)
            }
        )
    }
    
    func searchWithParams(params: [String: String], completion: (movies: [Movie]?, error: NSError?) -> ()) {
            var parameters = params
            parameters["apikey"] = apiKey
            GET("movies.json" ,
                parameters: parameters,
                success: { (operation:AFHTTPRequestOperation!, response:AnyObject!) -> Void in
                    //println("search movies: \(response)")
                    let movieList = response["movies"] as [NSDictionary]
                    var movies = Movie.moviesWithArray(movieList)
                    completion(movies: movies, error: nil)
                }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                    println("error getting timeline")
                    //self.loginCompletion? (user: nil, error: error)
                    completion(movies: nil, error: error)
            })
    }

    func getMovieDetail(movieId: String, completion: (movie: Movie?, error: NSError?) -> ()) {
        var parameters = ["apikey" : apiKey]
        GET("movies/\(movieId).json", parameters: parameters,
            success: { (operation:AFHTTPRequestOperation!, response:AnyObject!) -> Void in
                //println("movie: \(response)")
                var movie = Movie(dictionary: response as NSDictionary, isDetail: true)
                completion(movie: movie, error: nil)
            },
            failure: { (operation: AFHTTPRequestOperation!, error:NSError!) -> Void in
                println("error getting movie info from Rotten Tomatoes")
                completion(movie: nil, error: error)
            }
        )
    }
    
}
