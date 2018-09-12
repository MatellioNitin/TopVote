//
//  PFActivity.swift
//  TopVote
//
//  Created by Kurt Jensen on 3/1/16.
//  Copyright © 2016 TopVote. All rights reserved.
//

import UIKit
import Parse

enum ActivityType : Int {
    case entrySubmitted = 0
    case entryVotedOn
    case entryCommentedOn
    case entryShared
}

class PFActivity: PFObject, PFSubclassing {
    
    @NSManaged var user: PFVoter!
    @NSManaged var competition: PFCompetition?
    @NSManaged var entry: PFEntry?
    @NSManaged var type: Int
    
    class func parseClassName() -> String {
        return "Activity"
    }
    
    convenience init(competition: PFCompetition?, entry: PFEntry?, type: ActivityType) {
        self.init()
        self.user = PFVoter.current()!
        self.competition = competition
        self.entry = entry
        self.type = type.rawValue
    }
    
    func isMine() -> Bool {
        return entry?.user?.objectId == PFVoter.current()?.objectId
    }
    
    class func queryWithIncludes() -> PFQuery<PFObject>? {
        let query = PFActivity.query()
        query?.includeKey("user")
        query?.includeKey("competition")
        query?.includeKey("entry")
        query?.includeKey("entry.competition")
        query?.includeKey("entry.user")
        return query
    }
    
    class func queryMyActions() -> PFQuery<PFObject>? {
        if let entryQuery = PFEntry.myEntriesQuery() {
            let query = PFActivity.queryWithIncludes()
            query?.whereKey("entry", matchesQuery: entryQuery)
            query?.order(byDescending: "createdAt")
            return query
        }
        
        return nil
    }
    
    class func queryFollowingActions() -> PFQuery<PFObject>? {
        if let user = PFVoter.current(), let followingIds = user.followingIds {
            let followingQuery = PFVoter.query()
            followingQuery?.whereKey("objectId", containedIn: followingIds)
            if let followingQuery = followingQuery {
                let query = PFActivity.queryWithIncludes()
                query?.whereKey("user", matchesQuery: followingQuery)
                query?.order(byDescending: "createdAt")
                return query
            }
        }
        
        return nil
    }
    
    func toString() -> NSAttributedString? {
        let attributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.black, NSAttributedStringKey.font: Style.fontItalicWithSize(15), NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue] as! [String : Any];

        var string : NSMutableAttributedString = NSMutableAttributedString(string: "")
        if let type = ActivityType(rawValue: type) {
            if (isMine()) {
                switch (type) {
                case .entrySubmitted:
                    string = NSMutableAttributedString(string: "You've submitted an entry for the ")
                    if let competitionName = entry?.competition?.title {
                        let aString = NSMutableAttributedString(string: competitionName, attributes: attributes)
                        string.append(aString)
                    }
                    string.append(NSMutableAttributedString(string: " competition"))
                    break
                case .entryVotedOn:
                    if let userName = user?.username {
                        string = NSMutableAttributedString(string: userName, attributes: attributes)
                    }
                    string.append(NSMutableAttributedString(string: " voted for your entry"))
                    break
                case .entryCommentedOn:
                    if let userName = user?.username {
                        string = NSMutableAttributedString(string: userName, attributes: attributes)
                    }
                    string.append(NSMutableAttributedString(string: " commented on your entry"))
                    break
                case .entryShared:
                    if let userName = user?.username {
                        string = NSMutableAttributedString(string: userName, attributes: attributes)
                    }
                    string.append(NSMutableAttributedString(string: " shared your entry"))
                    break
                }
            } else {
                switch (type) {
                case .entrySubmitted:
                    if let userName = user?.username {
                        string = NSMutableAttributedString(string: userName, attributes: attributes)
                    }
                    string.append(NSMutableAttributedString(string: " submitted an entry for the "))
                    if let competitionName = entry?.competition?.title {
                        let aString = NSMutableAttributedString(string: competitionName, attributes: attributes)
                        string.append(aString)
                    }
                    string.append(NSMutableAttributedString(string: " competition"))
                    break
                case .entryVotedOn:
                    if let userName = user?.username {
                        string = NSMutableAttributedString(string: userName, attributes: attributes)
                    }
                    string.append(NSMutableAttributedString(string: " voted for "))
                    if let entryUserName = entry?.user?.username {
                        let aString = NSMutableAttributedString(string: entryUserName, attributes: attributes)
                        string.append(aString)
                        string.append(NSMutableAttributedString(string: "'s entry in the "))
                    }
                    if let competitionName = entry?.competition?.title {
                        let aString = NSMutableAttributedString(string: competitionName, attributes: attributes)
                        string.append(aString)
                    }
                    string.append(NSMutableAttributedString(string: " competition"))
                    break
                case .entryCommentedOn:
                    if let userName = user?.username {
                        string = NSMutableAttributedString(string: userName, attributes: attributes)
                    }
                    string.append(NSMutableAttributedString(string:  " commented on "))
                    if let entryUserName = entry?.user?.username {
                        let aString = NSMutableAttributedString(string: entryUserName, attributes: attributes)
                        string.append(aString)
                        string.append(NSMutableAttributedString(string: "'s entry in the "))
                    }
                    if let competitionName = entry?.competition?.title {
                        let aString = NSMutableAttributedString(string: competitionName, attributes: attributes)
                        string.append(aString)
                    }
                    string.append(NSMutableAttributedString(string: " competition"))
                    break
                case .entryShared:
                    if let userName = user?.username {
                        string = NSMutableAttributedString(string: userName, attributes: attributes)
                    }
                    string.append(NSMutableAttributedString(string: " shared "))
                    if let entryUserName = entry?.user?.username {
                        let aString = NSMutableAttributedString(string: entryUserName, attributes: attributes)
                        string.append(aString)
                        string.append(NSMutableAttributedString(string: "'s entry in the "))
                    }
                    if let competitionName = entry?.competition?.title {
                        let aString = NSMutableAttributedString(string: competitionName, attributes: attributes)
                        string.append(aString)
                    }
                    string.append(NSMutableAttributedString(string: " competition"))
                    break
                }
            }
        }
        return string
    }
    
}
