//
//  PFEntry.swift
//  TopVote
//
//  Created by Kurt Jensen on 3/1/16.
//  Copyright © 2016 TopVote. All rights reserved.
//

import UIKit
import Parse

class PFEntry: PFObject, PFSubclassing {

    @NSManaged var competition: PFCompetition!
    @NSManaged var competitionId: String?
    @NSManaged var user: PFVoter!
    @NSManaged var location: PFGeoPoint?
    @NSManaged var locationName: String?
    @NSManaged var subTitle: String?
    @NSManaged var title: String?
    @NSManaged var type: Int
    @NSManaged var imageURL: String?
    @NSManaged var videoURL: String?
    @NSManaged var numberShares: Int
    @NSManaged var numberVotes: Int
    @NSManaged var valueVotes: Int
    @NSManaged var rank: Int
    
    class func parseClassName() -> String {
        return "Entry"
    }
    
    convenience init(competition: PFCompetition, location: PFGeoPoint?, locationName: String?, title: String, subTitle: String, type: MediaType, imageURL: String?, videoURL: String?) {
        self.init()
        self.competition = competition
        self.competitionId = competition.objectId
        self.user = PFVoter.current()!
        self.location = location
        self.locationName = locationName
        self.title = title
        self.subTitle = subTitle
        self.type = type.rawValue
        self.imageURL = imageURL
        self.videoURL = videoURL
    }
    
    var awardImage: UIImage? {
        if (rank == 1) {
            return UIImage(named: "trophy_gold")
        } else if (rank == 2) {
            return UIImage(named: "trophy_silver")
        } else if (rank == 3) {
            return UIImage(named: "trophy_bronze")
        } else if (rank > 0 && rank <= 10) {
            return UIImage(named: "ribbon_blue")
        } else {
            return nil
        }
    }
    
    var shareURL: URL? {
        return URL(string: "http://www.topvote.com/competition/\(competitionId ?? "undefined")/entry/\(objectId ?? "undefined")")
    }
    
    func isAuthor() -> Bool {
        return user.objectId == PFVoter.current()?.objectId
    }
    
    func voteOn(_ value: Int, completion: (()->Void)?) {
        if let user = PFVoter.current() {
            let query = PFVote.query()
            query?.whereKey("user", equalTo: user)
            query?.whereKey("entry", equalTo: self)
            query?.getFirstObjectInBackground(block: { (vote, error) -> Void in
                if let vote = vote as? PFVote {
                    // update
                    let difference = value - vote.value
                    if (difference != 0) {
                        vote.value = value
                        vote.saveInBackground()
                        self.incrementKey("valueVotes", byAmount: NSNumber(value: difference))
                        self.saveInBackground()
                        PFCloud.callFunction(inBackground: "incrementEntryVote", withParameters: ["entryId": self.objectId ?? "", "userId": PFVoter.current()?.objectId ?? "", "valueVotesReceived": difference], block: { (result, error) in
                        })
                    }
                    PFVote.addRecentVote(vote)
                    completion?()
                } else {
                    // create new
                    let vote = PFVote(entry: self, value: value)
                    vote.saveInBackground()
                    self.incrementKey("valueVotes", byAmount: NSNumber(value: value))
                    self.incrementKey("numberVotes", byAmount: 1)
                    self.saveInBackground()
                    PFCloud.callFunction(inBackground: "incrementEntryVote", withParameters: ["entryId": self.objectId ?? "", "userId": PFVoter.current()?.objectId ?? "", "valueVotesReceived": value, "numberVotesReceived": 1], block: { (result, error) in
                    })
                    let activity = PFActivity(competition: nil, entry: self, type: ActivityType.entryVotedOn)
                    activity.saveInBackground()
                    PFVote.addRecentVote(vote)
                    completion?()
                }
            })
        }
    }

    class func entriesForUserCompetionQuery(_ user: PFUser, competition: PFCompetition) -> PFQuery<PFObject>? {
        let entryQuery = PFEntry.queryWithIncludes()
        entryQuery?.whereKey("user", equalTo: user)
        entryQuery?.whereKey("competition", equalTo: competition)
        return entryQuery
    }
    
    class func entriesForUserQuery(_ user: PFUser) -> PFQuery<PFObject>? {
        let entryQuery = PFEntry.queryWithIncludes()
        entryQuery?.whereKey("user", equalTo: user)
        return entryQuery
    }
    
    class func myEntriesQuery() -> PFQuery<PFObject>? {
        if let user = PFVoter.current() {
            return PFEntry.entriesForUserQuery(user)
        }
        return nil
    }
    
    class func queryWithIncludes() -> PFQuery<PFObject>? {
        let query = PFEntry.query()
        query?.includeKey("user")
        query?.includeKey("competition")
        return query
    }
    
}
