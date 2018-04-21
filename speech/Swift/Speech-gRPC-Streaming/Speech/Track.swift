//
//  Track.swift
//  Speech
//
//  Created by ChihYing on 4/20/18.
//  Copyright © 2018 Google. All rights reserved.
//

import Foundation

struct Track {
    let albumID: Int?
    let albumName: String?
    let artistID: Int?
    let artistName: String?
    let firstReleaseDate: String?
    let hasLyrics: Int?
    let hasSubtitles: Int?
    let lyricsID: Int!
    let trackID: Int!
    let trackName: String?
    let trackShareUrl: String?
    
    init(dictionary: [String:AnyObject]) {
        albumID = dictionary[Constants.MusixmatchResponseKeys.AlbumID] as? Int
        albumName = dictionary[Constants.MusixmatchResponseKeys.AlbumName] as? String
        artistID = dictionary[Constants.MusixmatchResponseKeys.ArtistID] as? Int
        artistName = dictionary[Constants.MusixmatchResponseKeys.ArtistName] as? String
        firstReleaseDate = dictionary[Constants.MusixmatchResponseKeys.FirstReleaseDate] as? String
        hasLyrics = dictionary[Constants.MusixmatchResponseKeys.HasLyrics] as? Int
        hasSubtitles = dictionary[Constants.MusixmatchResponseKeys.HasSubtitles] as? Int
        lyricsID = dictionary[Constants.MusixmatchResponseKeys.LyricsID] as! Int
        trackID = dictionary[Constants.MusixmatchResponseKeys.TrackID] as? Int
        trackName = dictionary[Constants.MusixmatchResponseKeys.TrackName] as? String
        trackShareUrl = dictionary[Constants.MusixmatchResponseKeys.TrackShareURL] as? String
    }
    
    
    static func tracksFromResult(_ results: [[String:AnyObject]]) -> [Track] {
        
        var tracks = [Track]()
        
        for result in results {
            tracks.append(Track(dictionary: result["track"] as! [String : AnyObject]))
        }
        print("tracks : \(tracks)")
        return tracks
    }
}
