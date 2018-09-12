//
//  IdeaTableViewCell.swift
//  TopVote
//
//  Created by Kurt Jensen on 4/11/16.
//  Copyright © 2016 TopVote. All rights reserved.
//

import UIKit

protocol IdeaTableViewCellDelegate {
    func voteIdea(_ cell: IdeaTableViewCell, idea: Idea)
}

class IdeaTableViewCell: UITableViewCell {

    @IBOutlet weak var voteButton: UIButton!
    @IBOutlet weak var ideaLabel: UILabel!
    @IBOutlet weak var ideaVotesLabel: UILabel!
    var delegate: IdeaTableViewCellDelegate?
    var idea: Idea!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureWithIdea(_ idea: Idea, delegate: IdeaTableViewCellDelegate?) {
        self.idea = idea
        ideaLabel.text = idea.text
        self.delegate = delegate
        refreshVotes()
    }
    
    func refreshVotes() {
        voteButton.isEnabled = true
        voteButton.isSelected = idea.hasVoted ?? false
        ideaVotesLabel.text = "\(idea.numberOfVotes ?? 0) total votes"
    }

    @IBAction func voteTapped(_ sender: AnyObject) {
        voteButton.isEnabled = false
        delegate?.voteIdea(self, idea: idea)
    }
}
