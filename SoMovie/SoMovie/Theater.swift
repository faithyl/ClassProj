//
//  Theater.swift
//  SoMovie
//
//  Created by Faith Cox on 10/15/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

import UIKit

class Theater: NSObject {
    
    var id : String
    var name : String
    var street : String
    var city : String
    var state : String
    var postalCode : String
    var country : String
    var distance: Double
    var telephone : String
    var longitude : String
    var latitude : String

    
    init(dictionary: NSDictionary) {
        id = dictionary["theatreId"] as String!
        name = dictionary["name"] as String
        if let location = dictionary["location"] as? NSDictionary {
            let address = location["address"] as [String:String]
            street = address["street"] as String!
            city = address["city"] as String!
            state = address["state"] as String!
            postalCode = address["postalCode"] as String!
            country = address["country"] as String!
            distance = location["distance"] as Double!
            telephone = (location["telephone"] as String!) ?? ""
            let geoCode = location["geoCode"] as [String:String]
            longitude = geoCode["longitude"] as String!
            latitude = geoCode["latitude"] as String!
        } else {
            street = ""
            city = ""
            state = ""
            postalCode = ""
            country = ""
            distance = 0
            telephone = ""
            longitude = ""
            latitude = ""
        }
    }
    
    class func theatersWithArray(array: [NSDictionary]) -> [Theater] {
        var theaters = [Theater]()
        for dictionary in array {
            theaters.append(Theater(dictionary: dictionary))
        }
        return theaters
    }

}
