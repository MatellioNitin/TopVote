//
//  StatTableViewCell.swift
//  TopVote
//
//  Created by Kurt Jensen on 6/18/16.
//  Copyright © 2016 TopVote. All rights reserved.
//

import UIKit

class StatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var innerContentView: UIView!
    @IBOutlet weak var statNameLabel: UILabel!
    @IBOutlet weak var statValueLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var profileViewsLabel: UILabel!
    @IBOutlet weak var dateJoinedLabel: UILabel!
    @IBOutlet weak var competitionsEnteredLabel: UILabel!
    @IBOutlet weak var competitionsWonLabel: UILabel!
    @IBOutlet weak var votesReceivedLabel: UILabel!
    @IBOutlet weak var votesGivenLabel: UILabel!
    
    var dateFormatter = DateFormatter()

    override func awakeFromNib() {
        dateFormatter.dateStyle = .short
        dateFormatter.dateFormat = "M-d-YY"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layoutSubviews()
        innerContentView.dropShadow(nil, CGSize(width: -1, height: 1), 2, 0.1, #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    }

    func configure(withAccount account: Account) {
        followersLabel.text = "\(account.followers ?? 0)"
        profileViewsLabel.text = "\(account.profileViews ?? 0)"
        competitionsEnteredLabel.text = "\(account.competitionsEntered ?? 0)"
        competitionsWonLabel.text = "\(account.competitionsWon ?? 0)"
        votesReceivedLabel.text = "\(account.votesReceived ?? 0)"
        votesGivenLabel.text = "\(account.votesGiven ?? 0)"
        
        if let date = account.createdAt {
            dateJoinedLabel.text = dateFormatter.string(from: date)
        }
    }
}
