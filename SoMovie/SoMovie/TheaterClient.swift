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
    
    func getTheaterShowtimes(params: [String: String], completion: (theaters: [Theater]?, error: NSError?) -> ()) {
        var parameters = params
        
        var theaterId = parameters.removeValueForKey("theaterId") as String!
        parameters["api_key"] = theaterapiKey
        
        var todaysDate:NSDate = NSDate()
        var dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var DateInFormat:String = dateFormatter.stringFromDate(todaysDate)
        
        GET("theatres/\(theaterId)/showings?startDate=\(todaysDate)", parameters: parameters,
            success: { (operation:AFHTTPRequestOperation!, response:AnyObject!) -> Void in
                println("theaters showtime: \(response)")
                var theaters = Theater.theatersWithArray(response as [NSDictionary])
                completion(theaters: theaters, error: nil)
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("error getting Theaters")
                completion(theaters: nil, error: error)
            }
        )
    }


}
