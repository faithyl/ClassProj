//
//  Showtime.swift
//  SoMovie
//
//  Created by Faith Cox on 10/18/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

import UIKit

class Showtime: NSObject {
    
    var theaterId : String
    var theaterName : String
    var barg : Int
    var dateTime : String
    var ticketURI : String
    var quals : String
    
    init(dictionary: NSDictionary) {
        var theatre = dictionary["theatre"] as NSDictionary
        theaterId = theatre["id"] as String!
        theaterName = theatre["name"] as String!
        barg = dictionary["barg"] as Int!
        dateTime = dictionary["dateTime"] as String!
        ticketURI = dictionary["ticketURI"] as String!
        quals = dictionary["quals"] as String!
    }
    
    
    class func showtimesWithArray(array: [NSDictionary]) -> [Showtime] {
        var showtimes = [Showtime]()
        for dictionary in array {
            showtimes.append(Showtime(dictionary: dictionary))
        }
        return showtimes
    }


    
}
