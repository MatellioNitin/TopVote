//
//  AwardedEntryTableViewCell.swift
//  TopVote
//
//  Created by Kurt Jensen on 7/22/16.
//  Copyright © 2016 TopVote. All rights reserved.
//

import UIKit

class AwardedEntryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var entryImageView: UIImageView!
    @IBOutlet weak var entryAwardImageView: UIImageView!
    @IBOutlet weak var competitionLabel: UILabel!
    @IBOutlet weak var awardLabel: UILabel!
    @IBOutlet weak var giftLabel: UILabel!
    
    var entry: Entry!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //entryAwardImageView?.sd_cancelCurrentImageLoad()
        entryAwardImageView?.image = nil
        awardLabel.text = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureWithEntry(_ entry: Entry) {
        self.layoutSubviews()
        
        self.entry = entry
        entryAwardImageView.image = entry.awardImage

        competitionLabel.text = entry.competition?.title
        if let rank = entry.rank {
            if (rank == 1) {
                awardLabel.text = "1st place"
            } else if (rank == 2) {
                awardLabel.text = "2nd place"
            } else if (rank == 3) {
                awardLabel.text = "3rd place"
            } else if (rank > 0 && rank <= 10) {
                awardLabel.text = "Top 10 finish"
            }
        }
        
        if entry.rank == 1 && (entry.competition?.giftCardURL != nil && entry.competition?.giftCardURL != "")
        {
            giftLabel.isHidden = false
        }
        else
        {
            giftLabel.isHidden = true
        }

        if let currentUser = AccountManager.session?.account, currentUser._id != entry.account?._id {
            giftLabel.isHidden = true
        }
        
        if let date = entry.createdAt {
            timeLabel.text = date.timeAgo
        }
    }
    
}
