//
//  SearchResaultViewController.swift
//  Speech
//
//  Created by ChihYing on 4/16/18.
//  Copyright © 2018 Google. All rights reserved.
//

import UIKit

class SearchResaultViewController: UIViewController {
    
    var result : [String:AnyObject]!
    var tracks : [Track]!
    var speechResult :String!
    var fullSize : CGSize!
    @IBOutlet weak var trackScrollViewTopConstraint: NSLayoutConstraint!
    
    var currentIndex = 0
    
    
    @IBOutlet weak var trackScrollView: UIScrollView!
    @IBOutlet weak var speechResultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        speechResultLabel.text = speechResult!
        
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
            trackScrollView.addSubview(trackView)
        }
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
    
    
}

extension SearchResaultViewController : UIScrollViewDelegate {
    
}
