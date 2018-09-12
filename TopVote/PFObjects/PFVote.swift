//
//  PFVote.swift
//  TopVote
//
//  Created by Kurt Jensen on 3/2/16.
//  Copyright © 2016 TopVote. All rights reserved.
//

import UIKit
import Parse

class NSVote: NSObject, NSCoding {
    var objectId: String!
    var value: Int = 0
    
    convenience init(objectId: String, value: Int) {
        self.init()
        self.objectId = objectId
        self.value = value
    }
    
    // MARK: NSCoding
    
    required convenience init?(coder decoder: NSCoder) {
        guard let objectId = decoder.decodeObject(forKey: "objectId") as? String
            else { return nil }
        let value = decoder.decodeInteger(forKey: "value")
        
        self.init(
            objectId: objectId,
            value: value
        )
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.objectId, forKey: "objectId")
        coder.encode(self.value, forKey: "value")
    }

}

class PFVote: PFObject, PFSubclassing {

    @NSManaged var entry: PFEntry!
    @NSManaged var user: PFVoter!
    @NSManaged var value: Int
    
    static var recentVotes = [NSVote]() {
        didSet {
            let recentVoteData = NSKeyedArchiver.archivedData(withRootObject: PFVote.recentVotes)
            UserDefaults.standard.set(recentVoteData, forKey: "KEY_RECENT_VOTE_DATA")
        }
    }
    static let maxHistory = 100
    
    class func parseClassName() -> String {
        return "Vote"
    }
    
    convenience init(entry: PFEntry, value: Int) {
        self.init()
        self.entry = entry
        self.user = PFVoter.current()!
        self.value = value
    }
    
    class func hasVotedForEntry(_ entry: PFEntry) -> Bool {
        var hasVotedForEntry = false
        for vote in PFVote.recentVotes {
            if (vote.objectId == entry.objectId) {
                hasVotedForEntry = vote.value > 0
            }
        }
        return hasVotedForEntry
    }
    
    class func addRecentVote(_ recentVote: PFVote) {
        PFVote.recentVotes.append(NSVote(objectId: recentVote.entry.objectId ?? "", value: recentVote.value))
        while (PFVote.recentVotes.count > PFVote.maxHistory) {
            PFVote.recentVotes.removeFirst()
        }
    }
    
}
