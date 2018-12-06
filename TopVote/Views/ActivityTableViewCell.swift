//
//  ActivityTableViewCell.swift
//  TopVote
//
//  Created by Kurt Jensen on 3/1/16.
//  Copyright © 2016 TopVote. All rights reserved.
//

import UIKit
//import SDWebImage

class ActivityTableViewCell: EntryTableViewCell {

    @IBOutlet weak var activityTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        activityTextLabel.text = nil
    }
    
    func configureWithActivity(_ activity: Activity) {
        if let entry = activity.entry {
            super.configureWithEntry(entry, compact: true,selectedTab:1)
        }
        if let date = activity.createdAt {
            timeLabel?.text = date.timeAgo
        }
        activityTextLabel.attributedText = activity.toString()
    }

}
