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
    
    func getTheaters(theaterZip: String, completion: (theaters: [Theater]?, error: NSError?) -> ()) {
        var parameters = ["api_key" : theaterapiKey]
        
        GET("theatres?zip=\(theaterZip)", parameters: parameters,
            success: { (operation:AFHTTPRequestOperation!, response:AnyObject!) -> Void in
                println("get theaters: \(response)")
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
