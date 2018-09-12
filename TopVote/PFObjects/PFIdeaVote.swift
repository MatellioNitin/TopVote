//
//  PFIdeaVote.swift
//  TopVote
//
//  Created by Kurt Jensen on 4/11/16.
//  Copyright © 2016 TopVote. All rights reserved.
//

import UIKit
import Parse

class PFIdeaVote: PFObject, PFSubclassing {
    
    @NSManaged var idea: PFIdea!
    @NSManaged var user: PFVoter!
    @NSManaged var value: Int
    
    static var recentIdeaVotes = [NSVote]() {
        didSet {
            let recentIdeaVoteData = NSKeyedArchiver.archivedData(withRootObject: PFIdeaVote.recentIdeaVotes)
            UserDefaults.standard.set(recentIdeaVoteData, forKey: "KEY_RECENT_IDEA_VOTE_DATA")
        }
    }
    static let maxHistory = 100
    
    class func parseClassName() -> String {
        return "IdeaVote"
    }
    
    convenience init(idea: PFIdea, value: Int) {
        self.init()
        self.idea = idea
        self.user = PFVoter.current()!
        self.value = value
    }
    
    class func hasVotedForIdea(_ idea: PFIdea) -> Bool {
        var hasVotedForIdea = false
        for recentIdeaVote in PFIdeaVote.recentIdeaVotes {
            if (recentIdeaVote.objectId == idea.objectId) {
                hasVotedForIdea = recentIdeaVote.value > 0
            }
        }
        return hasVotedForIdea
    }
    
    class func addRecentIdeaVote(_ recentIdeaVote: PFIdeaVote) {
        PFIdeaVote.recentIdeaVotes.append(NSVote(objectId: recentIdeaVote.idea.objectId ?? "", value: recentIdeaVote.value))
        while (PFIdeaVote.recentIdeaVotes.count > PFIdeaVote.maxHistory) {
            PFIdeaVote.recentIdeaVotes.removeFirst()
        }
    }
    
}
