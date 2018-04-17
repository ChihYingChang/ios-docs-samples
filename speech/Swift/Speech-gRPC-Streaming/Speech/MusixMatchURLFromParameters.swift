//
//  MusixMatchURLFromParameters.swift
//  Speech
//
//  Created by ChihYing on 4/16/18.
//  Copyright © 2018 Google. All rights reserved.
//

import Foundation

func MusixMatchURLFromParameters(_ parameters: [String:AnyObject]) -> URL {
    
    var components = URLComponents()
    components.scheme = Constants.Musixmatch.ApiScheme
    components.host = Constants.Musixmatch.ApiHost
    components.path = Constants.Musixmatch.ApiPath
    components.queryItems = [URLQueryItem]()
    
    for (key, value) in parameters {
        let queryItem = URLQueryItem(name: key, value: "\(value)")
        components.queryItems!.append(queryItem)
    }
    
    return components.url!
}
