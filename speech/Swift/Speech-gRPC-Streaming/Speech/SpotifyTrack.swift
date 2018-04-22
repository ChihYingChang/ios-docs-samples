//
//  SpotifyTrack.swift
//  Speech
//
//  Created by ChihYing on 4/22/18.
//  Copyright © 2018 Google. All rights reserved.
//

import Foundation

struct SpotifyTrack {
    let uri: String!
    var image: String?
    
    init(dictionary: [String:AnyObject]) {
        uri = dictionary[Constants.SpotifyTrackResponseKeys.uri] as! String
        if let array = dictionary[Constants.SpotifyTrackResponseKeys.album] as? [String:AnyObject] {
            if let images = array["images"] as? [[String:AnyObject]] {
                if let bigImage = images[0] as? [String : AnyObject] {
                    image = bigImage["url"] as? String
                }
            }
        }
    }
    
    
    static func trackFromResult(_ result: [String:AnyObject]!) -> SpotifyTrack {
        
        return SpotifyTrack(dictionary: result)
    }
}
