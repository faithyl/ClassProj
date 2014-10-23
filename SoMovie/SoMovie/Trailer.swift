//
//  Trailer.swift
//  SoMovie
//
//  Created by Faith Cox on 10/21/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

import UIKit

class Trailer: NSObject {
    var movieTitle : String
    var trailerDesc : String
    var dateAdded : String
    var studio : String
    var year : String
    var eclipId : String
    var trailerTypeId : Int
    var trailerVersion : Int
    var lang : String
    var runtime : Int
    var ratingId : Int
    var bitrateId : Int
    var formatId : Int
    var rootId : Int
    var url : String
    
    init(dictionary: NSDictionary) {
        movieTitle = dictionary["Title"] as String
        trailerDesc = dictionary["Description"] as String
        dateAdded = dictionary["DateAdded"] as String
        studio = dictionary["Studio"] as String
        year = dictionary["Year"] as String
        eclipId = dictionary["EClipId"] as String
        trailerTypeId = dictionary["TrailerTypeId"] as Int
        trailerVersion = dictionary["TrailerVersion"] as Int
        lang = dictionary["LanguageName"] as String
        runtime = dictionary["Runtime"] as Int
        ratingId = dictionary["RatingId"] as Int
        bitrateId = dictionary["BitrateId"] as Int
        formatId = dictionary["FormatId"] as Int
        rootId = dictionary["RootId"] as Int
        url = dictionary["Url"] as String
    }
    
    class func trailerWithArray(array: [NSDictionary]) -> [Trailer] {
        var trailers = [Trailer]()
        for dictionary in array {
            trailers.append(Trailer(dictionary: dictionary))
        }
        return trailers
    }
    
}
