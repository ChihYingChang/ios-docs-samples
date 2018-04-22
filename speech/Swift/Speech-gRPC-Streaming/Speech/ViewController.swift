//
// Copyright 2016 Google Inc. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
import UIKit
import AVFoundation
import googleapis

let SAMPLE_RATE = 16000

class ViewController : UIViewController, AudioControllerDelegate {
  @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    var audioData: NSMutableData!
  var speechResult: String?

  override func viewDidLoad() {
    super.viewDidLoad()
    AudioController.sharedInstance.delegate = self
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.isTranslucent = true
  }
    
    override func viewWillAppear(_ animated: Bool) {
        textView.text = ""
        speechResult = nil
        UIView.animate(withDuration: 2.0, animations: {
            self.stopButton.alpha = 1.0
            self.recordButton.alpha = 1.0
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        stopButton.alpha = 0.0
        recordButton.alpha = 0.0
    }

  @IBAction func recordAudio(_ sender: NSObject) {
    let audioSession = AVAudioSession.sharedInstance()
    do {
      try audioSession.setCategory(AVAudioSessionCategoryRecord)
    } catch {

    }
    audioData = NSMutableData()
    _ = AudioController.sharedInstance.prepare(specifiedSampleRate: SAMPLE_RATE)
    SpeechRecognitionService.sharedInstance.sampleRate = SAMPLE_RATE
    _ = AudioController.sharedInstance.start()
  }

  @IBAction func stopAudio(_ sender: NSObject) {
    _ = AudioController.sharedInstance.stop()
    SpeechRecognitionService.sharedInstance.stopStreaming()
    if (speechResult != nil && !(speechResult?.isEmpty)!) {
        callMusicMatch()
    }
  }

  func processSampleData(_ data: Data) -> Void {
    audioData.append(data)

    // We recommend sending samples in 100ms chunks
    let chunkSize : Int /* bytes/chunk */ = Int(0.1 /* seconds/chunk */
      * Double(SAMPLE_RATE) /* samples/second */
      * 2 /* bytes/sample */);

    if (audioData.length > chunkSize) {
      SpeechRecognitionService.sharedInstance.streamAudioData(audioData,
                                                              completion:
        { [weak self] (response, error) in
            guard let strongSelf = self else {
                return
            }
            
            if let error = error {
                strongSelf.textView.text = error.localizedDescription
            } else if let response = response {
//                var finished = false
                
                for result in response.resultsArray! {
                    
                    if let result = result as? StreamingRecognitionResult {
                        if result.isFinal {
//                            finished = true
                            
                            strongSelf.speechResult = (result.alternativesArray[0] as AnyObject).transcript
                        }
                    }
                }
                strongSelf.textView.text = response.description
//                if finished {
//                    strongSelf.stopAudio(strongSelf)
//                }
            }
      })
      self.audioData = NSMutableData()
    }
  }
    
    private func callMusicMatch() {
        
//        print(" speechResult : \(speechResult!)")
        
        /* 1. Set the parameters */
        let methodParameters = [
            Constants.MusixmatchParameterKeys.Format : Constants.MusixmatchParameterValue.Format,
            Constants.MusixmatchParameterKeys.Callback : Constants.MusixmatchParameterValue.Callback,
            Constants.MusixmatchParameterKeys.QLyrics : speechResult!,
//            Constants.MusixmatchParameterKeys.SArtistRating : Constants.MusixmatchParameterValue.SArtistRating,
//            Constants.MusixmatchParameterKeys.STrackRating : Constants.MusixmatchParameterValue.STrackRating,
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
                
                let tracks = Track.tracksFromResult(trackList)
                self.pushToNextController(tracks: tracks)
            }
            
        }
        
        /* 7. Start the request */
        task.resume()
    }
    
    private func pushToNextController(tracks: [Track]!) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SearchResaultViewController") as! SearchResaultViewController
        nextViewController.speechResult = speechResult!
        nextViewController.tracks = tracks
        self.present(nextViewController, animated:true, completion:nil)
        
    }
    
}
