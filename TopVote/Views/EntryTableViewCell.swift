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
    func volumeMedia(_ cell: EntryTableViewCell)
    func shareEntry(_ entry: Entry)
    func voteEntry(_ cell: EntryTableViewCell, entry: Entry, isUnVote:Bool)
    func voteEntryDoubleTap(_ cell: EntryTableViewCell, entry: Entry, isUnVote:Bool)
    func commentEntry(_ entry: Entry)
    func moreEntry(_ entry: Entry)
}

class EntryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var moreButton: RoundedButton?
    @IBOutlet weak var shareButton: RoundedButton?
    @IBOutlet weak var commentButton: RoundedButton?
    @IBOutlet weak var voteButton: RoundedButton?
    
    @IBOutlet weak var commentLeading: NSLayoutConstraint!
    @IBOutlet weak var commentWidth: NSLayoutConstraint!
    @IBOutlet weak var innerContentView: UIView?
    @IBOutlet weak var timeLabel: UILabel?
    //@IBOutlet weak var captionButton: UIButton?
    
    @IBOutlet weak var lblCaption: UILabel!
    @IBOutlet weak var volumeButton: UIButton?

    @IBOutlet weak var userImageView: RoundedImageView?
    @IBOutlet weak var entryImageView: RoundedImageView?
    @IBOutlet weak var userNameLabel: UILabel?
    @IBOutlet weak var locationLabel: UILabel?
    @IBOutlet weak var mediaView: MediaView!
    //@IBOutlet weak var starStackView: UIStackView!
    @IBOutlet weak var totalVotesLabel: UILabel?
    @IBOutlet weak var competitionLabel: UILabel?
    
    @IBOutlet weak var btnEntryInProfile: UIButton!
    @IBOutlet weak var textTypeLabel: UILabel?

    private var dateFormatter: DateFormatter?
    
    @IBOutlet weak var voteButtonWidth: NSLayoutConstraint?
    @IBOutlet weak var voteButtonLeading: NSLayoutConstraint?
    
    
    var delegate: EntryTableViewCellDelegate?
    
    var entry: Entry?
    var status: Int = 0
    var isCompact: Bool = false
    var tapGR2: UITapGestureRecognizer?
    var voteGR: UILongPressGestureRecognizer?
    
    
    
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
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        
//        if(!self.isCompact){
         self.tapGR2 = UITapGestureRecognizer(target: self, action: #selector(EntryTableViewCell.playMediaTapped))
        self.tapGR2!.numberOfTapsRequired = 1
        self.mediaView.addGestureRecognizer(self.tapGR2!)
        
         self.voteGR = UILongPressGestureRecognizer(target: self, action: #selector(EntryTableViewCell.voteButtonTapped(_:)))
        self.voteGR!.minimumPressDuration = 2
        self.entryImageView?.addGestureRecognizer(self.voteGR!)
        
       // }
      //  }
        
        let voteDoubleTap = UITapGestureRecognizer(target: self, action: #selector(EntryTableViewCell.voteDoubleTapped))
        voteDoubleTap.numberOfTapsRequired = 2
        mediaView.addGestureRecognizer(voteDoubleTap)
        
        let voteTextDoubleTap = UITapGestureRecognizer(target: self, action: #selector(EntryTableViewCell.voteDoubleTapped))
        voteTextDoubleTap.numberOfTapsRequired = 2
        textTypeLabel?.addGestureRecognizer(voteTextDoubleTap)
        
        
        
//        let tapVolume = UITapGestureRecognizer(target: self, action: #selector(EntryTableViewCell.playMediaTapped))
//        tapVolume.numberOfTapsRequired = 1
//        volumeButton?.addGestureRecognizer(tapVolume)
        
        volumeButton?.addTarget(self, action:#selector(EntryTableViewCell.volumeMediaTapped), for: .touchUpInside)
        
        
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
    
    func configureWithEntry(_ entry: Entry, compact: Bool, isComeFromProfile:Bool = false, selectedTab:Int, isVideoMuted:Bool = false) {
        self.layoutSubviews()
        
        self.entry = entry
        isCompact = compact
       
        if(self.entry?.mediaType == "TEXT"){
            textTypeLabel?.text = self.entry?.competition?.text
             self.entryImageView?.image = UIImage(named: "textImage")
        }
        else if let mediaType = entry.mediaType {
            lblCaption?.isHidden = true

            if let mediaUri = entry.mediaUri, let uri = URL(string: mediaUri) {
                if mediaType == "IMAGE-VIDEO" {
                    if mediaUri.contains(".jpg") || mediaUri.contains(".jpeg") || mediaUri.contains(".png") ||  mediaUri.contains(".gif") {
                        self.entryImageView?.af_setImage(withURL: uri, placeholderImage: UIImage(named: "loading"), imageTransition: .crossDissolve(0.30), runImageTransitionIfCached: true)
                        if (compact) {
                           // entryImageView!.isUserInteractionEnabled = false
                            //entryImageView!.removeGestureRecognizer(voteGR!)

                        }
                        
                    } else {
                        self.mediaView.addPlayer(uri)
                        if let lblCaption = self.lblCaption {
                            self.bringSubview(toFront: lblCaption)
                        }
                        if (compact) {

                           // mediaView.isUserInteractionEnabled = false
                            //mediaView.removeGestureRecognizer(tapGR2!)

                        }
                        self.lblCaption?.isHidden = false
                    }
                }
                else if mediaType == "IMAGE" {
                    entryImageView?.af_setImage(withURL: uri, placeholderImage: UIImage(named: "loading"), imageTransition: .crossDissolve(0.30), runImageTransitionIfCached: true)
                    self.lblCaption?.isHidden = false
                    if (compact) {
                        //entryImageView!.removeGestureRecognizer(voteGR!)

                       // entryImageView!.isUserInteractionEnabled = false
                    }

                } else if mediaType == "VIDEO" || (mediaType == "IMAGE-VIDEO" && (entry.mediaUri?.contains(".mov"))!) {
                    
                    mediaView.addPlayer(uri)

                    if let lblCaption = lblCaption {
                        self.bringSubview(toFront: lblCaption)
                    }
                    lblCaption?.isHidden = false
                    if (compact) {
                        //mediaView.removeGestureRecognizer(tapGR2!)

                       // mediaView.isUserInteractionEnabled = false
                    }
                }
            }
            NSLog("Profile Name \(entry.account?.username)")
            NSLog("Profile image \(entry.account?.profileImageUri)")
            if let profileImageUri = entry.account?.profileImageUri, let uri = URL(string: profileImageUri) {
                userImageView?.af_setImage(withURL: uri, placeholderImage: UIImage(named: "profile-default-avatar"), imageTransition: .crossDissolve(0.30), runImageTransitionIfCached: false)
            } else {
                userImageView?.image = UIImage(named: "profile-default-avatar")
            }
            
            

        }
        
        userNameLabel?.text = entry.account?.username ?? entry.account?.name
        locationLabel?.text = entry.locationName ?? ""
        if let date = entry.createdAt {
            if (compact) {
                timeLabel?.text = date.timeAgo
            } else {
                if let dateFormatter = dateFormatter {
                    timeLabel?.text = dateFormatter.string(from: date)
                }
            }
        }
      //  if(AccountManager.session?.account?._id == entry.account?._id){
//        }
//        else
//        {
//            shareButton?.isHidden = true
//        }
        if(selectedTab == 2){
            shareButton?.isHidden = true
        }
        else
        {
            shareButton?.isHidden = false

        }
        
        if(lblCaption != nil){
            lblCaption.text = entry.title
        }
       // captionButton?.setTitle("greer gergregerggeerggergeggerg er gergerg er gg g erg g re gre ge gr greg e", for: .normal)
     
        if(isComeFromProfile && entry.competition == nil){
            competitionLabel?.text = entry.privateCompetition?.title
        }
        else
        {
            competitionLabel?.text = entry.competition?.title

        }
 
        
        refreshVotes()
    }
    
    func toggleMedia() {
        if (mediaView.player?.rate != 1.0) {
            mediaView.player?.play()
        } else {
            mediaView.player?.pause()
        }
    }
    
    func toggleVolume() {
//        DispatchQueue.main.async {
        
        
        
            if (self.mediaView.player?.isMuted == false) {
//            self.mediaView.player?.isMuted = true
            self.volumeButton?.setImage(UIImage(named:"soundOff"), for: .normal)


        } else {
//            self.mediaView.player?.volume = .greatestFiniteMagnitude
//            self.mediaView.playe r?.volume = 0.0
//            self.mediaView.player?.isMuted = false
            self.volumeButton?.setImage(UIImage(named:"soundOn"), for: .normal)

//        }
        }
        self.mediaView.player?.isMuted =  !(self.mediaView.player?.isMuted)!

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
//    
//    func volumeButtonAction() {
//        
//        if(isVideoMuted){
//            isVideoMuted =  false
//        }
//        else {
//            isVideoMuted =  true
//        }
//        
//        let indexPath = IndexPath(item: sender.tag - 1, section: 1)
//        
//        //IndexPath(forRow: sender.tag - 1, inSection: 0)
//        
//        self.tableView.reloadRows(at: [indexPath], with: .none)
//    }
    
    
    
    
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
        //voteButton?.isEnabled = true
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
    
    @objc func volumeMediaTapped() {
        self.delegate?.volumeMedia(self)
    }
    
    @objc func showProfileTapped() {
        guard let entry = entry else {
            return
        }
        if let account = entry.account {
            self.delegate?.showUser(account)
        }
    }
    
    @objc func voteDoubleTapped() {
        if(status == 0 && !isCompact){

        guard let entry = entry else {
            return
        }
//        if (entry.competition?.status != 0) {
            if(entry.hasVoted != true){
                // self.voteButton?.isEnabled = false
                self.delegate?.voteEntryDoubleTap(self, entry:entry, isUnVote:false)
            }
            else
            {
              //  self.delegate?.voteEntryDoubleTap(self, entry:entry, isUnVote:true)
            }
       // }
        }
    }
    
    @objc func voteButtonTapped(_ sender: UILongPressGestureRecognizer) {
        
        if(status == 0){

        guard let entry = entry else {
            return
        }
      //  if (entry.competition?.status != 0) {
        if (sender.state == UIGestureRecognizerState.began) {
            
            if(entry.hasVoted != true){
                // self.voteButton?.isEnabled = false
                self.delegate?.voteEntry(self, entry:entry, isUnVote:false)
            }
            else
            {
                self.delegate?.voteEntry(self, entry:entry, isUnVote:true)
                }
            }
        }
    }
    
    @IBAction func voteButtonClicked(_ sender: AnyObject?) {
        guard let entry = entry else {
            return
        }
        
        if(entry.hasVoted != true){
           // self.voteButton?.isEnabled = false
            self.delegate?.voteEntry(self, entry:entry, isUnVote:false)
            
        }
        else
        {
           self.delegate?.voteEntry(self, entry:entry, isUnVote:true)
            
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
