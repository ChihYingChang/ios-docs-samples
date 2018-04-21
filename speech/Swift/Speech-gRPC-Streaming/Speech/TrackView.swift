//
//  TrackView.swift
//  Speech
//
//  Created by ChihYing on 4/20/18.
//  Copyright © 2018 Google. All rights reserved.
//

import UIKit

class TrackView: UIView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var trackName: UILabel!
    
    @IBOutlet weak var artist: UILabel!
    
    @IBOutlet weak var lyrics: UITextView!
    
    @IBOutlet weak var album: UILabel!
    
    var lyricID: Int!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
//        setGradientBg(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setUp() {
        Bundle.main.loadNibNamed("TrackView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
    }
    
//    private func setGradientBg(frame: CGRect) {
//        let layer = CAGradientLayer()
//        layer.frame = frame
//        layer.colors = [UIColor.red.cgColor, UIColor.black.cgColor]
//        contentView.layer.addSublayer(layer)
//    }
    
}
