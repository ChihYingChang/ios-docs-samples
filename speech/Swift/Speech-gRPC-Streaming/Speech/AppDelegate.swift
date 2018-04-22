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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,
                SPTAppRemoteDelegate,
                SPTAppRemotePlayerStateDelegate, SPTAudioStreamingDelegate {
    
    // MARK : Using the Spotify built-in Authorization flow
    // Referance : https://gist.github.com/jackfreeman/a2f3140cf1eeb438079e12996050ae26
    
    var auth : SPTAuth!
    var player : SPTAudioStreamingController!
    var authViewController : UIViewController!
    
    lazy var appRemote: SPTAppRemote = {
        let connectionParams = SPTAppRemoteConnectionParams(clientIdentifier: "5224c2c1fd86452794471533278892c4",
                                                            redirectURI: "lyrics-search://callback",
                                                            name: "LyricsSearch",
                                                            accessToken: nil,
                                                            defaultImageSize: CGSize.zero,
                                                            imageFormat: .any)
        let appRemote = SPTAppRemote(connectionParameters: connectionParams, logLevel: .debug)
        appRemote.delegate = self
        return appRemote
    }()


  var window: UIWindow?

  func application
    (_ application: UIApplication,
     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil)
    -> Bool {
//        DispatchQueue.main.async {
//            let uri = "spotify:artist:04gDigrS5kc9YWfZHwBETP"
//            let spotifyInstalled = self.appRemote.authorizeAndPlayURI(uri)
//            if !spotifyInstalled {
//                /*
//                 * The Spotify app is not installed.
//                 * Use SKStoreProductViewController with SPTAppRemote.spotifyItunesItemIdentifier()
//                 * to present the user with a way to install the Spotify app.
//                 */
//            }
//        }
        
//        auth = SPTAuth.defaultInstance()
//        player = SPTAudioStreamingController.sharedInstance()
//        auth.clientID = "5224c2c1fd86452794471533278892c4"
//        auth.redirectURL = URL(string: "lyrics-search://callback")
//        auth.sessionUserDefaultsKey = "SpotifySession"
//        auth.requestedScopes = [SPTAuthStreamingScope]
//        player.delegate = self
        
//        var audioStreamingInitError : Error
//        let condition = player.start(withClientId: <#T##String!#>)
//        assert(condition, "There was a problem starting the Spotify SDK : \(audioStreamingInitError.localizedDescription)")
//        DispatchQueue.main.async {
//            self.startAuthenticationFlow()
//        }
        
        return true
  }
    
//    func startAuthenticationFlow() {
//         // Check if we could use the access token we already have
//        if auth.session.isValid() {
//            // Use it to log in
//            player.login(withAccessToken: auth.session.accessToken)
//        } else {
//            // Get the URL to the Spotify authorization portal
//            let authURL = auth.spotifyWebAuthenticationURL()
//            authViewController = SFSafariViewController.init(url: authURL!)
//            window?.rootViewController?.present(authViewController, animated: true, completion: nil)
//        }
//
//    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        
//        if auth.canHandle(url) {
//            authViewController.presentingViewController?.dismiss(animated: true, completion: nil)
//            authViewController = nil
//            auth.handleAuthCallback(withTriggeredAuthURL: url, callback: { (erroe, session) in
//                    if (session != nil) {
//                        self.player.login(withAccessToken: self.auth.session.accessToken)
//                    }
//                })
//            return true
//        }
//        return false
        
        let parameters = appRemote.authorizationParameters(from: url)

        if let access_token = parameters?[SPTAppRemoteAccessTokenKey] {
            appRemote.connectionParameters.accessToken = access_token
        } else if let error_description = parameters?[SPTAppRemoteErrorDescriptionKey] {
            debugPrint(error_description)
        }

        return true
    }
    
//    func audioStreamingDidLogin(audioStreaming : SPTAudioStreamingController) {
//        player.playSpotifyURI("spotify:track:58s6EuEYJdlb0kO7awm3Vp", startingWith: 0, startingWithPosition: 0) { (error) in
//            if error != nil {
//                print("*** failed to play: \(error!)")
//                return
//            }
//        }
//    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        if appRemote.isConnected {
            appRemote.disconnect()
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        if let _ = appRemote.connectionParameters.accessToken {
            appRemote.connect()
        }
    }

 
    // MARK: - SPTAppRemoteDelegate

    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        // Connection was successful, you can begin issuing commands
        appRemote.playerAPI?.delegate = self
        appRemote.playerAPI?.subscribe(toPlayerState: { (result, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
            }
        })
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        // Connection failed
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        // Connection disconnected
    }
    
    // MARK: - SPTAppRemotePlayerStateDelegate
    
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        debugPrint("Track name: %@", playerState.track.name)
    }
    
}

extension AppDelegate {
 
    func callSpotify(uri : String) {
            DispatchQueue.main.async {
                let uri = uri
                let spotifyInstalled = self.appRemote.authorizeAndPlayURI(uri)
                if !spotifyInstalled {
                    /*
                     * The Spotify app is not installed.
                     * Use SKStoreProductViewController with SPTAppRemote.spotifyItunesItemIdentifier()
                     * to present the user with a way to install the Spotify app.
                     */
                }
            }
    }
}
