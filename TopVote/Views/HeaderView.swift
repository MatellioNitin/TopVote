//
//  ProfileHeaderView.swift
//  Topvote
//
//  Copyright © 2017 TopVote. All rights reserved.
//

import UIKit

protocol HeaderViewDelegate {
    func typeChanged(_ type: Int)
}

class HeaderView: UIView {
    
    @IBOutlet weak var innerContentView: UIView!
    
    var delegate: HeaderViewDelegate?
    
    func refreshView(_ user: Account) {
        backgroundColor = Style.barTintColor
    }

    @IBAction func controlChanged(_ sender: UISegmentedControl) {
        delegate?.typeChanged(sender.selectedSegmentIndex)
    }

}

protocol ProfileHeaderViewDelegate {
    func showFollowers()
    func showFollowing()
    func followTappped()
}

class ProfileHeaderView: UIView {
    
    @IBOutlet weak var backgroundContainerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var bioView: UIView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var followerButton: UIButton!
    @IBOutlet weak var followersButton: UIButton!
    @IBOutlet weak var followingButton: UIButton!
    @IBOutlet weak var followButtonWidthContraint: NSLayoutConstraint!
    @IBOutlet weak var bioViewTrailingConstraint: NSLayoutConstraint!
    
    var delegate: ProfileHeaderViewDelegate?
    
    func refreshView(_ user: Account?) {
//        backgroundColor = Style.barTintColor
//        for view in subviews {
//            view.backgroundColor = Style.barTintColor
//        }
        
        if let user = user {
            if let profileImageUri = user.profileImageUri, let uri = URL(string: profileImageUri) {
                imageView?.af_setImage(withURL: uri, placeholderImage: nil, imageTransition: .crossDissolve(0.30), runImageTransitionIfCached: false)
            } else {
                imageView?.image = UIImage(named: "profile-default-avatar")
            }

            followersButton.titleLabel?.textAlignment = .center
            followingButton.titleLabel?.textAlignment = .center
            
            
            nameLabel.text = user.name
            if(nameLabel.text == nil || nameLabel.text == ""){
                nameLabel.text = user.username
            }
            else if(user.name == "" && user.username == ""){
                nameLabel.text = "Amazing Voter"
            }
            
            
         //   nameLabel.text = user.name ?? user.username ?? "Amazing Voter"
            bioLabel.text = user.bio
            locationLabel.text = user.locationName
           // locationLabel.sizeToFit()
            followersButton.setTitle("\(user.userFollowers?.count ?? 0)", for: UIControlState())
            followingButton.setTitle("\(user.userFollowing?.count ?? 0)", for: UIControlState())
            
//            followersButton.setTitle("\(user.followers ?? 0)", for: UIControlState())
//            followingButton.setTitle("\(user.following ?? 0)", for: UIControlState())
            
            if let currentUser = AccountManager.session?.account, currentUser._id != user._id {
                let isFollowing = user.followingAccount ?? false
                followerButton.setTitle(isFollowing ? "Unfollow" : "Follow", for: .normal)
            } else {
                followButtonWidthContraint.constant = 0
                bioViewTrailingConstraint.constant = 0
            }
        }
    }
    
    @IBAction func followersTapped(_ sender: AnyObject) {
        delegate?.showFollowers()
    }
    
    @IBAction func followingTapped(_ sender: AnyObject) {
        delegate?.showFollowing()
    }
    
    @IBAction func followTapped(_ sender: UIButton) {
        followerButton.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.followerButton.isUserInteractionEnabled = true

        }
        delegate?.followTappped()
    }
    
}
