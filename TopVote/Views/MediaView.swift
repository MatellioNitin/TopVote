//
//  MediaView.swift
//  TopVote
//
//  Created by Kurt Jensen on 6/18/16.
//  Copyright © 2016 TopVote. All rights reserved.
//

import UIKit
import AVFoundation

class MediaView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        playerLayer?.frame = self.bounds
    }

    
    func addPlayer(_ url: URL) {
        removePlayer()
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer!.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerLayer!.frame = bounds
        player?.volume = 0.0
        layer.insertSublayer(playerLayer!, at: 0)
    }
    
    func removePlayer() {
        stopPlaying()
        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
        player = nil
    }
    
    func stopPlaying() {
        player?.pause()
    }
    
    func startPlaying() {
        self.player?.seek(to: kCMTimeZero)
        self.player?.play()
    }
    
}
