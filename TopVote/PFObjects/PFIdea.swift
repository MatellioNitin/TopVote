//
//  PFIdea.swift
//  TopVote
//
//  Created by Kurt Jensen on 3/10/16.
//  Copyright © 2016 TopVote. All rights reserved.
//

import UIKit
import Parse

class PFIdea: PFObject, PFSubclassing {
    
    @NSManaged var text: String?
    @NSManaged var user: PFVoter?
    @NSManaged var numberVotes: Int
    @NSManaged var valueVotes: Int
    
    class func parseClassName() -> String {
        return "Idea"
    }
    
    convenience init(text: String?) {
        self.init()
        self.text = text
        self.user = PFVoter.current()
    }
    
    func voteOn(_ value: Int, completion: (()->Void)?) {
        if let user = PFVoter.current() {
            let query = PFIdeaVote.query()
            query?.whereKey("user", equalTo: user)
            query?.whereKey("idea", equalTo: self)
            query?.getFirstObjectInBackground(block: { (vote, error) -> Void in
                if let vote = vote as? PFIdeaVote {
                    // update
                    let difference = value - vote.value
                    if (difference != 0) {
                        vote.value = value
                        vote.saveInBackground()
                        self.incrementKey("valueVotes", byAmount: NSNumber(value: difference))
                        self.saveInBackground()
                    }
                    PFIdeaVote.addRecentIdeaVote(vote)
                    completion?()
                } else {
                    // create new
                    let vote = PFIdeaVote(idea: self, value: value)
                    vote.saveInBackground()
                    self.incrementKey("valueVotes", byAmount: NSNumber(value: value))
                    self.incrementKey("numberVotes", byAmount: 1)
                    self.saveInBackground()
                    PFIdeaVote.addRecentIdeaVote(vote)
                    completion?()
                }
            })
        }
    }
    
}
