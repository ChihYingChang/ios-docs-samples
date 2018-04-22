//
//  SpotifyURLCreator.swift
//  Speech
//
//  Created by ChihYing on 4/22/18.
//  Copyright © 2018 Google. All rights reserved.
//

import Foundation

func SpotifyURLFromParameters(_ parameters: [String:AnyObject]) -> URL {
    
    var components = URLComponents()
    components.scheme = Constants.Spotify.ApiScheme
    components.host = Constants.Spotify.ApiHost
    components.path = Constants.Spotify.ApiPath
    components.queryItems = [URLQueryItem]()
    
    for (key, value) in parameters {
        let queryItem = URLQueryItem(name: key, value: "\(value)")
        components.queryItems!.append(queryItem)
    }
    
    return components.url!
}
