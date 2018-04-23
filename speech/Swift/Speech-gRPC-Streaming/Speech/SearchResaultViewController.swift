//
//  SearchResaultViewController.swift
//  Speech
//
//  Created by ChihYing on 4/16/18.
//  Copyright © 2018 Google. All rights reserved.
//

import UIKit

class SearchResaultViewController: UIViewController {
    
    var appDelegate: AppDelegate!
    
    var result : [String:AnyObject]!
    var tracks : [Track]!
    var speechResult :String!
    var fullSize : CGSize!
    var currentIndex = 0
    
    @IBOutlet weak var trackScrollViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var spotifyButton: UIButton!
    
    @IBOutlet weak var trackScrollView: UIScrollView!
//    @IBOutlet weak var speechResultLabel: UILabel!
    @IBOutlet weak var resultTextField: UITextView!
    
    @IBOutlet weak var pageNum: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultTextField.text = speechResult!
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        setScrollView()
    }

    private func setScrollView() {
        
        fullSize = UIScreen.main.bounds.size
        trackScrollView.contentSize = CGSize(width: fullSize.width * CGFloat(tracks.count), height: fullSize.height - trackScrollViewTopConstraint.constant)
        trackScrollView.contentOffset = CGPoint(x: fullSize.width * CGFloat(currentIndex), y: 0.0)
        trackScrollView.isDirectionalLockEnabled = false
        
        let margin = CGFloat(40)
        var trackView : TrackView
        for i in 0...tracks.count - 1 {
            trackView = TrackView(frame: CGRect(x: 0.0, y: 0.0, width: fullSize.width - margin, height: fullSize.height - margin - trackScrollViewTopConstraint.constant ))
            trackView.center = CGPoint(x: fullSize.width * (0.5 + CGFloat(i)), y: (fullSize.height - margin - trackScrollViewTopConstraint.constant) * (0.5) )
            trackView.contentView.layer.cornerRadius = 13
            trackView.tag = i + 1  // page
            trackView.trackName.text = tracks[i].trackName
            trackView.artist.text = tracks[i].artistName
            trackView.lyricID = tracks[i].lyricsID
            
            setAlbumAndDate(trackView: trackView, index: i)
            getLyric(trackID: tracks[i].trackID)
            getSpotifyTrackID(trackView: trackView, track: tracks[i])
            trackScrollView.addSubview(trackView)
        }
    }
    
     func removeTrackViews() {
        let subViews = trackScrollView.subviews
        for subview in subViews{
            subview.removeFromSuperview()
        }
    }
    
    private func getSpotifyTrackID(trackView : TrackView, track : Track) {
        
//        let albumName = track.albumName
        let artistName = track.artistName
        let trackName = track.trackName
        
        let q = String.init(format:"artist:%@ track:%@",artistName!,trackName!)
        
        /* 1. Set the parameters */
        let methodParameters = [
            Constants.SpotifySearchParameterKeys.q : q ,
            Constants.SpotifySearchParameterKeys.type :  Constants.SpotifySearchParameterValues.track,
            Constants.SpotifySearchParameterKeys.market : Constants.SpotifySearchParameterValues.USMarket,
            Constants.SpotifySearchParameterKeys.limit : Constants.SpotifySearchParameterValues.limit
            ] as [String : AnyObject]
        
        // create session and request
        let session = URLSession.shared
        var request = URLRequest(url: SpotifyURLFromParameters(methodParameters))
        request.httpMethod = "GET"
        request.addValue(Constants.SpotifyHeaderValues.Accept, forHTTPHeaderField: Constants.SpotifyHeaderKeys.Accept)
        request.addValue(Constants.SpotifyHeaderValues.ContentType, forHTTPHeaderField: Constants.SpotifyHeaderKeys.ContentType)
        request.addValue(Constants.SpotifyHeaderValues.Authorization, forHTTPHeaderField: Constants.SpotifyHeaderKeys.Authorization)
        
        print("request \(request)")
        
        // Make the request
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard (error == nil) else {
                print("There was an error with the request: \(error!)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("The request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            
            // parse the data
            let parsedResults: [String:AnyObject]!
            do {
                parsedResults = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
            } catch {
                return
            }
            
            print(parsedResults)
            
            guard let tracks = parsedResults["tracks"] as? [String : AnyObject] else {
                print("There is no tracks!")
                return
            }
            
            guard let items = tracks["items"] as? [[String : AnyObject]] else {
                print("There is no items!")
                return
            }
            
            guard items.count > 0 else {
                print("There is no the item!")
                return
            }
            
            // Store Value
            
            let spotifyTrack = SpotifyTrack.trackFromResult(items[0])
            
            trackView.spotifyTrackID = spotifyTrack.uri
            
            if let url = spotifyTrack.image {
                let imageURL = URL(string: url)
                let imageData:NSData = NSData(contentsOf: imageURL!)!
                
                // use Value
                
                performUIUpdatesOnMainThread {
                    trackView.coverImage.image = UIImage(data: imageData as Data)
                }
            }
            
       }
    
        task.resume()
}

    private func getLyric(trackID : Int) {
        
        /* 1. Set the parameters */
        let methodParameters = [
            Constants.MusixmatchParameterKeys.Format : Constants.MusixmatchParameterValue.Format,
            Constants.MusixmatchParameterKeys.Callback : Constants.MusixmatchParameterValue.Callback,
            Constants.MusixmatchParameterKeys.TrackID : trackID,
            Constants.MusixmatchParameterKeys.APIKey : Constants.MusixmatchParameterValue.APIKey
            ] as [String : AnyObject]
        
        /* 2/3. Build the URL, Configure the request */
        let session = URLSession.shared
        let request = URLRequest(url: MusixMatchLyricsURLFromParameters(methodParameters))
        
        /* 4. Make the request */
        let task = session.dataTask(with: request) { (data, response, error) in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(String(describing: error))")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            /* 5. Parse the data */
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
            } catch {
                print("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            guard let message = parsedResult["message"] as? [String : AnyObject] else {
                print("There is no message!")
                return
            }
            
            guard let body = message["body"] as? [String : AnyObject] else {
                print("There is no body!")
                return
            }
            
            guard let lyrics = body["lyrics"] as? [String : AnyObject] else {
                print("There is no lyrics!")
                return
            }
            
            /* 6. Use the data! */
            
            // update UI
            performUIUpdatesOnMainThread {
                let lyric = Lyric.lyricFromResult(lyrics)
                
                for trackView in self.trackScrollView.subviews {
                    if trackView is TrackView {
                        if (trackView as! TrackView).lyricID == lyric.lyricsID {
                           (trackView as! TrackView).lyrics.text = lyric.lyricsBody
                        }
                    }
                }
            }
            
        }
        
        /* 7. Start the request */
        task.resume()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backAction(_ sender: UIButton) {
         dismiss(animated: true, completion: nil)
    }
    
    @IBAction func calloutAction(_ sender: UIButton) {
        
            performUIUpdatesOnMainThread {
                if let view = self.trackScrollView.viewWithTag(self.page()) as? TrackView{
                    
                    if let spotifyTrackID =  view.spotifyTrackID {
                        self.appDelegate.callSpotify(uri: spotifyTrackID)
                    } else {
                        
                        
                        self.displayOKAlert(title: "There is no audio track!" ,message: "")
//                        print("There is no audio track! : \(view.trackName.text)")
                        return
                    }
                    
                }
            }

    }
    
    private func displayOKAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    private func setAlbumAndDate(trackView : TrackView , index :Int) {
        
        
        if let album = tracks[index].albumName {
            if let date = tracks[index].firstReleaseDate {
                var newDate = date
                if date.count > 10 {
                    let otherRange = date.index(date.startIndex, offsetBy: 10)..<date.endIndex
                    newDate.removeSubrange(otherRange)
                }
                trackView.album.text = "\(album) | \(newDate)"
            } else {
                trackView.album.text = "\(album)"
            }
        } else {
            trackView.album.text = nil
        }
    }
    
    func page()-> Int{
        return currentIndex + 1
    }
    
    func callMusicMatch(newText : String) {
        
        //        print(" speechResult : \(speechResult!)")
        
        /* 1. Set the parameters */
        let methodParameters = [
            Constants.MusixmatchParameterKeys.Format : Constants.MusixmatchParameterValue.Format,
            Constants.MusixmatchParameterKeys.Callback : Constants.MusixmatchParameterValue.Callback,
            Constants.MusixmatchParameterKeys.QLyrics : newText,
            //            Constants.MusixmatchParameterKeys.SArtistRating : Constants.MusixmatchParameterValue.SArtistRating,
            Constants.MusixmatchParameterKeys.STrackRating : Constants.MusixmatchParameterValue.STrackRating,
            Constants.MusixmatchParameterKeys.FHasLyrics : Constants.MusixmatchParameterValue.FHasLyrics,
            Constants.MusixmatchParameterKeys.QuorumFactor : Constants.MusixmatchParameterValue.QuorumFactor,
            Constants.MusixmatchParameterKeys.PageSize : Constants.MusixmatchParameterValue.PageSize,
            Constants.MusixmatchParameterKeys.Page : Constants.MusixmatchParameterValue.Page,
            Constants.MusixmatchParameterKeys.APIKey : Constants.MusixmatchParameterValue.APIKey
            ] as [String : AnyObject]
        
        /* 2/3. Build the URL, Configure the request */
        let session = URLSession.shared
        let request = URLRequest(url: MusixMatchURLFromParameters(methodParameters))
        
        //        print("request : \(request)")
        
        /* 4. Make the request */
        let task = session.dataTask(with: request) { (data, response, error) in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(String(describing: error))")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            /* 5. Parse the data */
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
            } catch {
                print("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            guard let message = parsedResult["message"] as? [String : AnyObject] else {
                print("There is no message!")
                return
            }
            
            guard let body = message["body"] as? [String : AnyObject] else {
                print("There is no body!")
                return
            }
            
            guard let trackList = body["track_list"] as? [[String : AnyObject]] else {
                print("There is no track_list!")
                return
            }
            
            
            /* 6. Use the data! */
            
            // update UI
            performUIUpdatesOnMainThread {
                
                self.tracks = Track.tracksFromResult(trackList)
                self.setScrollView()

            }
            
        }
        
        /* 7. Start the request */
        task.resume()
    }
    
    
}

extension SearchResaultViewController : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        currentIndex = Int(scrollView.contentOffset.x / fullSize.width)
        pageNum.text = "\(page())"
    }
    
}

extension SearchResaultViewController : UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            textView.resignFirstResponder()
            print(textView.text + text)
            let newText = textView.text
            if (newText?.count)! > 0 {
                speechResult = newText
                removeTrackViews()
                callMusicMatch(newText: newText!)
            } else {
                dismiss(animated: true, completion: nil)
            }
            
        }
        
        return true
    }
    
    
    
}
