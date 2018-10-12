//
//  TableViewCell.swift
//  Super
//
//  Created by Matthew Arkin on 11/9/14.
//  Copyright (c) 2014 Super. All rights reserved.
//

import UIKit
import AVFoundation
import AlamofireImage
//import FontAwesomeKit
//import Parse

protocol EntryTableViewCellDelegate {
    func showUser(_ user: Account)
    func playMedia(_ cell: EntryTableViewCell)
    func shareEntry(_ entry: Entry)
    func voteEntry(_ cell: EntryTableViewCell, entry: Entry)
    func commentEntry(_ entry: Entry)
    func moreEntry(_ entry: Entry)
}

class EntryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var moreButton: RoundedButton?
    @IBOutlet weak var shareButton: RoundedButton?
    @IBOutlet weak var commentButton: RoundedButton?
    @IBOutlet weak var voteButton: RoundedButton?
    
    @IBOutlet weak var innerContentView: UIView?
    @IBOutlet weak var timeLabel: UILabel?
    @IBOutlet weak var captionButton: UIButton?
    @IBOutlet weak var userImageView: RoundedImageView?
    @IBOutlet weak var entryImageView: RoundedImageView?
    @IBOutlet weak var userNameLabel: UILabel?
    @IBOutlet weak var locationLabel: UILabel?
    @IBOutlet weak var mediaView: MediaView!
    //@IBOutlet weak var starStackView: UIStackView!
    @IBOutlet weak var totalVotesLabel: UILabel?
    @IBOutlet weak var competitionLabel: UILabel?
    
    @IBOutlet weak var textTypeLabel: UILabel?

    private var dateFormatter: DateFormatter?
    
    var delegate: EntryTableViewCellDelegate?
    
    var entry: Entry?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        dateFormatter = DateFormatter()
        dateFormatter?.dateStyle = .short
        dateFormatter?.timeStyle = .short
        
        let tapImageGR = UITapGestureRecognizer(target: self, action: #selector(EntryTableViewCell.showProfileTapped))
        tapImageGR.numberOfTapsRequired = 1
        userImageView?.addGestureRecognizer(tapImageGR)

        let tapLabelGR = UITapGestureRecognizer(target: self, action: #selector(EntryTableViewCell.showProfileTapped))
        tapLabelGR.numberOfTapsRequired = 1
        userNameLabel?.addGestureRecognizer(tapLabelGR)

        let tapGR2 = UITapGestureRecognizer(target: self, action: #selector(EntryTableViewCell.playMediaTapped))
        tapGR2.numberOfTapsRequired = 1
        mediaView.addGestureRecognizer(tapGR2)
        
        let voteGR = UILongPressGestureRecognizer(target: self, action: #selector(EntryTableViewCell.voteButtonTapped(_:)))
        voteGR.minimumPressDuration = 2
        entryImageView?.addGestureRecognizer(voteGR)
        
        NotificationCenter.default.addObserver(self,
            selector: #selector(EntryTableViewCell.playerItemDidReachEnd(_:)),
            name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
            object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    @objc func playerItemDidReachEnd(_ notification: Notification) {
        if let avPlayerItem = notification.object as? AVPlayerItem {
            if (avPlayerItem == mediaView.player?.currentItem) {
                mediaView.startPlaying()
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mediaView.removePlayer()
        userImageView?.image = nil
        entryImageView?.image = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureWithEntry(_ entry: Entry, compact: Bool) {
        self.layoutSubviews()
        
        self.entry = entry
        if(self.entry?.mediaType == "TEXT"){
            textTypeLabel?.text = self.entry?.competition?.text
        }
        else if let mediaType = entry.mediaType {
            if let mediaUri = entry.mediaUri, let uri = URL(string: mediaUri) {
                if mediaType == "IMAGE" {
                    entryImageView?.af_setImage(withURL: uri, placeholderImage: UIImage(named: "loading"), imageTransition: .crossDissolve(0.30), runImageTransitionIfCached: false)
                } else if mediaType == "VIDEO" {
                    mediaView.addPlayer(uri)
                    if let captionButton = captionButton {
                        self.bringSubview(toFront: captionButton)
                    }
                }
            }

            if let profileImageUri = entry.account?.profileImageUri, let uri = URL(string: profileImageUri) {
                userImageView?.af_setImage(withURL: uri, placeholderImage: UIImage(named: "loading"), imageTransition: .crossDissolve(0.30), runImageTransitionIfCached: false)
            } else {
                userImageView?.image = UIImage(named: "profile-default-avatar")
            }
        }
        
        userNameLabel?.text = entry.account?.username ?? entry.account?.name
        locationLabel?.text = entry.locationName ?? "Not provided"
        if let date = entry.createdAt {
            if (compact) {
                timeLabel?.text = date.timeAgo
            } else {
                if let dateFormatter = dateFormatter {
                    timeLabel?.text = dateFormatter.string(from: date)
                }
            }
        }
        
        captionButton?.setTitle(entry.title, for: .normal)
        competitionLabel?.text = entry.competition?.title
        refreshVotes()
    }
    
    func toggleMedia() {
        if (mediaView.player?.rate != 1.0) {
            mediaView.player?.play()
        } else {
            mediaView.player?.pause()
        }
    }
    
    func startMedia() {
        if (mediaView.player?.rate != 1.0) {
            mediaView.player?.play()
        }
    }
    
    func stopMedia() {
        if (mediaView.player?.rate != 0.0) {
            mediaView.player?.pause()
        }
    }
    
    func refreshVotes() {
        guard let entry = entry else {
            return
        }
        /*let averageVote = Float(entry.valueVotes)/Float(entry.numberVotes)
        for subView in starStackView.arrangedSubviews {
            if let subButton = subView as? UIButton {
                subButton.setImage(starImageForSlot(subButton.tag, averageVote: averageVote), forState: .Normal)
            }
        }*/
        voteButton?.isEnabled = true
        voteButton?.isSelected = entry.hasVoted ?? false
        if let valueVotes = entry.valueVotes {
            totalVotesLabel?.text = "\(valueVotes) vote\(valueVotes == 0 || valueVotes > 1 ? "s" : "")"
        }
    }
    
    func starImageForSlot(_ slot: Int, averageVote: Float) -> UIImage? {
        if (averageVote >= Float(slot)) {
            return UIImage(named: "star_filled")
        } else if (averageVote >= Float(slot) - 0.5) {
            return UIImage(named: "star_half")
        } else {
            return UIImage(named: "star_empty")
        }
    }
    
    @objc func playMediaTapped() {
        self.delegate?.playMedia(self)
    }
    
    @objc func showProfileTapped() {
        guard let entry = entry else {
            return
        }
        if let account = entry.account {
            self.delegate?.showUser(account)
        }
    }
    
    @objc func voteButtonTapped(_ sender: UILongPressGestureRecognizer) {
        guard let entry = entry else {
            return
        }
        if (sender.state == UIGestureRecognizerState.began) {
            self.delegate?.voteEntry(self, entry:entry)
        }
    }
    
    @IBAction func voteButtonClicked(_ sender: AnyObject?) {
        guard let entry = entry else {
            return
        }
        
        if(entry.hasVoted != true){
            self.voteButton?.isEnabled = false
            self.delegate?.voteEntry(self, entry:entry)
        }
    }
    
    @IBAction func shareButtonPressed(_ sender: AnyObject) {
        guard let entry = entry else {
            return
        }
        self.delegate?.shareEntry(entry)
    }
    
    @IBAction func commentActionPressed(_ sender: AnyObject) {
        guard let entry = entry else {
            return
        }
        self.delegate?.commentEntry(entry)
    }
    
    @IBAction func moreButtonPressed(_ sender: AnyObject) {
        guard let entry = entry else {
            return
        }
        self.delegate?.moreEntry(entry)
    }
    
}
