//
//  PollTextTBCell.swift
//  Topvote
//
//  Created by Nitin on 03/04/19.
//  Copyright © 2019 Top, Inc. All rights reserved.
//

import UIKit
import AVFoundation
import AlamofireImage


protocol PollCellDelegate {
//    func playMedia(_ cell: PollTBCell)
//    func volumeMedia(_ cell: PollTBCell)
        func  voteEntry(index:Int)
}

class PollTBCell: UITableViewCell {

    //TextCell
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var btnVote: UIButton!
    @IBOutlet weak var lblVote: UILabel!
    
    @IBOutlet weak var bottomViewMargin: NSLayoutConstraint!
    @IBOutlet weak var topViewMargine: NSLayoutConstraint!
    
    @IBOutlet weak var lblOptionText: UILabel!
    //Image/Video
    @IBOutlet weak var viewImg: MediaView!
    @IBOutlet weak var imgPollView: UIImageView!
    @IBOutlet weak var btnVolume: UIButton!
    var delegate: PollCellDelegate?
    //var selected:String?
   // var entry: Options?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if(viewImg != nil){
        let tapGR2 = UITapGestureRecognizer(target: self, action: #selector(PollTBCell.playMediaTapped))
        tapGR2.numberOfTapsRequired = 1
        viewImg.addGestureRecognizer(tapGR2)
        }
        
//        if(btnVote != nil){
//        let voteGR = UILongPressGestureRecognizer(target: self, action: #selector(PollTBCell.voteButtonTapped(_:)))
//        voteGR.minimumPressDuration = 2
//        btnVote?.addGestureRecognizer(voteGR)
//        }
        
        if(btnVolume != nil){
        btnVolume?.addTarget(self, action:#selector(PollTBCell.volumeMediaTapped), for: .touchUpInside)
            
        NotificationCenter.default.addObserver(self, selector: #selector(PollTBCell.playerItemDidReachEnd(_:)),  name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,  object: nil)

        }

        
        // Initialization code
    }

    deinit {
        if(btnVolume != nil){

        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        }
    }
    
    @objc func playerItemDidReachEnd(_ notification: Notification) {
        if let avPlayerItem = notification.object as? AVPlayerItem {
            if (avPlayerItem == viewImg.player?.currentItem) {
                viewImg.startPlaying()
            }
        }
    }
   
    override func prepareForReuse() {
        super.prepareForReuse()
        if(viewImg != nil){
        viewImg.removePlayer()
        }
        if(imgPollView != nil){
        imgPollView?.image = nil
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func toggleMedia() {
        if (viewImg.player?.rate != 1.0) {
            viewImg.player?.play()
        } else {
            viewImg.player?.pause()
        }
    }
    
    func toggleVolume() {
        if (viewImg.player?.volume != 0) {
            
            btnVolume?.setImage(UIImage(named:"soundOff"), for: .normal)
            viewImg.player?.volume = 0
            
        } else {
            
            btnVolume?.setImage(UIImage(named:"soundOn"), for: .normal)
            viewImg.player?.volume = .greatestFiniteMagnitude
            
        }
        
    }
    
    func startMedia() {
        if (viewImg.player?.rate != 1.0) {
            viewImg.player?.play()
        }
    }
    
    func stopMedia() {
        if (viewImg.player?.rate != 0.0) {
            viewImg.player?.pause()
        }
    }
    
    
//    func refreshVotes() {
//        guard let entry = entry else {
//            return
//        }

//        btnVote?.isSelected = entry.hasVoted ?? false
//        if let valueVotes = entry.valueVotes {
//            lblVote?.text = "\(valueVotes) vote\(valueVotes == 0 || valueVotes > 1 ? "s" : "")"
//        }
  //  }
    
    @objc func playMediaTapped() {
        if (viewImg.player?.rate != 1.0) {
            viewImg.player?.play()
        } else {
            viewImg.player?.pause()
        }
       // self.delegate?.playMedia(self)
    }
    
    @objc func volumeMediaTapped() {
        if (viewImg.player?.volume != 0) {
            
            btnVolume?.setImage(UIImage(named:"soundOff"), for: .normal)
            viewImg.player?.volume = 0
            
        } else {
            
            btnVolume?.setImage(UIImage(named:"soundOn"), for: .normal)
            viewImg.player?.volume = .greatestFiniteMagnitude
            
        }
    }
    
//    @objc func voteButtonTapped(_ sender: UILongPressGestureRecognizer) {
//
////        guard let entry = entry else {
////            return
////        }
//        if (sender.state == UIGestureRecognizerState.began) {
    
//            if(entry.hasVoted != true){
//                // self.voteButton?.isEnabled = false
//                self.delegate?.voteEntry(self, entry:entry, isUnVote:false)
//            }
//            else
//            {
//                self.delegate?.voteEntry(self, entry:entry, isUnVote:true)
//            }
//        }
//    }
//
    
    @IBAction func voteButtonClicked(_ sender: AnyObject?) {
//        guard let entry = entry else {
//            return
//        }
        self.delegate?.voteEntry(index:(sender?.tag)!)

//        if(entry.selected != ""){
//            // self.voteButton?.isEnabled = false
//            self.delegate?.voteEntry(self, entry:entry, isUnVote:false)
//
//        }
//        else
//        {
//            self.delegate?.voteEntry(self, entry:entry, isUnVote:true)
//
//        }
        
        
        
    }
}
