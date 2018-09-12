//
//  UserTableViewCell.swift
//  TopVote
//
//  Created by Kurt Jensen on 4/11/16.
//  Copyright © 2016 TopVote. All rights reserved.
//

import UIKit
//import SDWebImage

class UserFollowTableViewCell: UserTableViewCell {
    
    @IBOutlet weak var followButton: UIButton!

    override func configureWithUser(_ user: Account) {
        super.configureWithUser(user)
        if let currentUser = AccountManager.session?.account {
            if let followingAccount = user.followingAccount {
                followButton.isSelected = followingAccount == true
            }
            followButton.isHidden = currentUser._id == user._id
        }
    }
    
    @IBAction func followTapped(_ sender: UIButton) {
        sender.isEnabled = false
        if let currentUser = AccountManager.session?.account, let user = user, let userId = user._id {
            let followingAccount = user.followingAccount ?? false
            if (!followingAccount) {
                Account.follow(accountId: userId, error: { (errorMessage) in
                    DispatchQueue.main.async {
                        sender.isEnabled = true;
                    }
                }, completion: { (followedAccount) in
                    DispatchQueue.main.async {
                        self.user = followedAccount
                        sender.isEnabled = true
                        self.followButton.isSelected = followedAccount.followingAccount == true
                        self.followButton.isHidden = currentUser._id == user._id
                    }
                })
            } else {
                Account.unfollow(accountId: userId, error: { (errorMessage) in
                    DispatchQueue.main.async {
                        sender.isEnabled = true;
                    }
                }, completion: { (unfollowedAccount) in
                    DispatchQueue.main.async {
                        self.user = unfollowedAccount
                        sender.isEnabled = true
                        self.followButton.isSelected = unfollowedAccount.followingAccount == true
                        self.followButton.isHidden = currentUser._id == user._id
                    }
                })
            }
        }
    }
    
}

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    var user: Account!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userImageView.image = nil
    }
    
    func configureWithUser(_ user: Account) {
        self.user = user
        if let profileImageUri = user.profileImageUri, let uri = URL(string: profileImageUri) {
            userImageView?.af_setImage(withURL: uri, placeholderImage: nil, imageTransition: .crossDissolve(0.30), runImageTransitionIfCached: false)
        }
        nameLabel.text = user.username
    }
    
}
