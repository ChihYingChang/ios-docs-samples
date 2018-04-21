//
//  Constants.swift
//  Speech
//
//  Created by ChihYing on 4/16/18.
//  Copyright © 2018 Google. All rights reserved.
//

import Foundation

struct Constants {
    
    struct Musixmatch {
        static let ApiScheme = "https"
        static let ApiHost = "api.musixmatch.com"
        static let ApiPath = "/ws/1.1/track.search"
        static let ApiLyricPath = "/ws/1.1/track.lyrics.get"
    }
    
    struct MusixmatchParameterKeys {
        static let Format = "format"
        static let Callback = "callback"
        static let QTrack = "q_track"
        static let QArtist = "q_artist"
        static let QLyrics = "q_lyrics"
//        static let Q = "q"
        static let FArtistID = "f_artist_id"
        static let FMusicGenreID = "f_music_genre_id"
        static let FLyricsLanguage = "f_lyrics_language"
        static let FHasLyrics = "f_has_lyrics"
        static let FisrtReleaseDateMin = "f_track_release_group_first_release_date_min"
        static let FisrtReleaseDateMax = "f_track_release_group_first_release_date_max"
        static let SArtistRating = "s_artist_rating"
        static let STrackRating = "s_track_rating"
        static let QuorumFactor = "quorum_factor"
        static let Page = "page"
        static let PageSize = "page_size"
        static let APIKey = "apikey"
        static let TrackID = "track_id"
        
    }
    
    // Fixed Value
    struct MusixmatchParameterValue {
        static let Format = "json"
        static let Callback = "callback"
        static let QTrack = ""
        static let QArtist = ""
        static let QLyrics = ""
        //        static let Q = "q"
        static let FArtistID = ""
        static let FMusicGenreID = ""
        static let FLyricsLanguage = "en"
        static let FHasLyrics = 1.0
        static let FisrtReleaseDateMin = ""
        static let FisrtReleaseDateMax = ""
        static let SArtistRating = "desc"
        static let STrackRating = "desc"
        static let QuorumFactor = 0.5
        static let Page = 1
        static let PageSize = 5
        static let APIKey = "2d31655277c161c72f42006282202cb3"
    }
    
    struct MusixmatchResponseKeys {
        static let TrackID = "track_id"
        static let TrackMbid = "track_mbid"
        static let TrackIsRc = "track_isrc"
        static let TrackSpotifyID = "track_spotify_id"
        static let TrackSoundCloudID = "track_soundcloud_id"
        static let TrrackXBoxmusixID = "track_xboxmusic_id"
        static let TrackName = "track_name"
        static let TrackRating = "track_rating"
        static let TrackLength = "track_length"
        static let CommontrackID = "commontrack_id"
        static let Instrumental = "instrumental"
        static let HasLyrics = "has_lyrics"
        static let HasLyricsCrowd = "has_lyrics_crowd"
        static let HasSubtitles = "has_subtitles"
        static let HasRichsync = "has_richsync"
        static let NumFavourite = "num_favourite"
        static let LyricsID = "lyrics_id"
        static let SubtitleID = "subtitle_id"
        static let AlbumID = "album_id"
        static let AlbumName = "album_name"
        static let ArtistID = "artist_id"
        static let ArtistMBid = "artist_mbid"
        static let ArtistName = "artist_name"
        static let AlbumCoverart100 = "album_coverart_100x100"
        static let AlbumCoverart350 = "album_coverart_350x350"
        static let AlbumCoverart500 = "album_coverart_500x500"
        static let AlbumCoverart800 = "album_coverart_800x800"
        
        static let TrackShareURL = "track_share_url"
        static let TrackEditURL = "track_edit_url"
        static let CommonTrackVanityID = "commontrack_vanity_id"
        static let Restricted = "restricted"
     
        static let FirstReleaseDate = "first_release_date"
        static let UpdatedTime = "updated_time"
        
        static let PrimaryGenres = "primary_genres"
        static let MusicGenreList = "music_genre_list"

        static let MusicGenre = "music_genre"
        static let SecondaryGenres = "secondary_genres"
    
    }
    
    struct MusixmatchLyricsResponseKeys {
        static let lyricsID = "lyrics_id"
        static let lyricsBody =  "lyrics_body"
        static let scriptTrackingUrl = "script_tracking_url"
        static let lyricsLanguageDescription = "lyrics_language_description"
    }
    
    
}
