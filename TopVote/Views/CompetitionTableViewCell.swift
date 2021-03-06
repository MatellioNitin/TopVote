//
//  CompetitionTableViewCell.swift
//  Super
//
//  Created by Matthew Arkin on 10/9/14.
//  Copyright (c) 2014 Super. All rights reserved.
//

import UIKit
import AlamofireImage

enum MediaType: Int {
    case image
    case video
}

class CompetitionTableViewCell: UITableViewCell {
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var byTextLabel: UILabel!

    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var winnerLabel: UILabel!
    
    @IBOutlet weak var winnerView: UIView!
    @IBOutlet weak var timeView: UIView!
    
    @IBOutlet weak var byImageView: UIImageView!
    
    @IBOutlet weak var hofBadgeImage: UIImageView!
    @IBOutlet weak var winnerProfileImage: UIImageView!
    
    @IBOutlet weak var badgeView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
//        for view in contentView.subviews {
//            //view.addShadow()
//        }
        let rect = CGRect(x: 0.0, y: 0.0, width: screenBounds.size.width - 20.0, height: 62.0)
        badgeView.dropShadow(rect, CGSize(width: 0, height: 1), 2, 0.1, #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //self.bgImageView.sd_cancelCurrentImageLoad()
        self.bgImageView.image = nil
        //self.byImageView.sd_cancelCurrentImageLoad()
        self.byImageView.image = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureWithCompetition(_ competition: Competition, tabbarIndex:Int) {
        titleLabel.text = competition.title?.uppercased()
        byTextLabel.text = competition.byText
        //byTextLabel.sizeToFit()
        
        if let winnerProfileURL = competition.winner?.account?.profileImageUri, let url = URL(string: winnerProfileURL) {
            winnerProfileImage.af_setImage(withURL: url, placeholderImage: UIImage(named: "profile-default-avatar"), imageTransition: .crossDissolve(0.30), runImageTransitionIfCached: false)
        }
        
        
        var byImage:String = ""
        if(competition.byImageUri != nil){
        if(tabbarIndex == 3){
            byImage = competition.profileImage!
            byTextLabel.text = competition.ownerName

        }
        else{
            byImage = competition.byImageUri!

        }
        }
        if let url = URL(string: byImage) {
            
            byImageView.af_setImage(withURL: url, placeholderImage: nil, imageTransition: .crossDissolve(0.30), runImageTransitionIfCached: false)
        }

       
        
        var imageName = ""
        
        switch competition.sType {
        case "poll"? : imageName = "poll"
        case "survey"? : imageName = "survey"
        default : print("Default")
            
        }
        
        if let type = competition.type {
            let photoimage = (MediaType(rawValue: type) == .image) ? UIImage(named: "icon-camera") : UIImage(named: "icon-video")
            typeImageView.image = photoimage
        }
        else{
            let photoimage =  UIImage(named: imageName)
            typeImageView.image = photoimage
        }
     
        
        var hasEnded = competition.hasEnded()
        let entryMediaType = competition.winner?.mediaType ?? ""
        if hasEnded {
            if entryMediaType == "VIDEO" {
                if let entryMediaUrl = competition.winner?.mediaUriThumbnail, let url = URL(string: entryMediaUrl) {
                    bgImageView.af_setImage(withURL: url, placeholderImage: nil, imageTransition: .crossDissolve(0.30), runImageTransitionIfCached: false)
                }
            } else {
                if let entryMediaUrl = competition.mediaUri, let url = URL(string: entryMediaUrl) {
                    bgImageView.af_setImage(withURL: url, placeholderImage: nil, imageTransition: .crossDissolve(0.30), runImageTransitionIfCached: false)
                }
            }
        } else {
            if let mediaUrl = competition.mediaUri, let url = URL(string: mediaUrl) {
                bgImageView.af_setImage(withURL: url, placeholderImage: nil, imageTransition: .crossDissolve(0.30), runImageTransitionIfCached: false)
            }
        }
        
        if(tabbarIndex != 2){
            hasEnded = false
        }
    
        hofBadgeImage.isHidden = !hasEnded
        winnerProfileImage.isHidden = !hasEnded
        winnerView.isHidden = !hasEnded
        timeView.isHidden = hasEnded
        timeRemainingLabel.isHidden = hasEnded
        timeRemainingLabel.text = competition.timeRemainingString()
        winnerLabel.text = competition.winnerString()
       
    
}
}
