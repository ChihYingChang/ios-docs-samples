//
//  Lyric.swift
//  Speech
//
//  Created by ChihYing on 4/20/18.
//  Copyright © 2018 Google. All rights reserved.
//

import Foundation

struct Lyric {
    let lyricsID: Int!
    let lyricsBody: String!
    let scriptTrackingUrl: String?
    let lyricsLanguageDescription: String?
    
    
    init(dictionary: [String:AnyObject]) {
        lyricsID = dictionary[Constants.MusixmatchLyricsResponseKeys.lyricsID] as? Int
        lyricsBody = dictionary[Constants.MusixmatchLyricsResponseKeys.lyricsBody] as? String
        scriptTrackingUrl = dictionary[Constants.MusixmatchLyricsResponseKeys.scriptTrackingUrl] as? String
        lyricsLanguageDescription = dictionary[Constants.MusixmatchLyricsResponseKeys.lyricsLanguageDescription] as? String
    }
    
    
    static func lyricFromResult(_ result: [String:AnyObject]) -> Lyric {
        
        return Lyric(dictionary: result)

    }
}
