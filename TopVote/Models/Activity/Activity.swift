//
//  Activity.swift
//  Topvote
//
//  Copyright © 2017 Top, Inc. All rights reserved.
//

import Foundation
import Moya
import Result

typealias Activities = [Activity]

enum ActivityType : String, Codable {
    case entrySubmitted = "ENTRYSUBMITTED"
    case entryVotedOn = "ENTRYVOTEDON"
    case entryCommentedOn = "ENTRYCOMMENTEDON"
    case entryShared = "ENTRYSHARED"
    case ideaVotedOn = "IDEAVOTEDON"
    case entryFlagOn = "ENTRYFLAGGEDON"

}




final class  Activity: Model {
    // MARK: * Properties
    
    var _id: String?
    
    var createdAt: Date?
    
    var updatedAt: Date?
    
    var competition: Competition?
    
    var account: Account?
    
    var entry: Entry?
    
    var idea: Idea?
    
    var type: ActivityType?
    
    // MARK: * Instant methods
    
    func isMine() -> Bool {
        return account?._id == AccountManager.session?.account?._id || entry?.account?._id == AccountManager.session?.account?._id || idea?.account?._id == AccountManager.session?.account?._id
    }
    
    func toString() -> NSAttributedString? {
        let userNameFont = UIFont(name: "Avenir-Heavy", size: 12.0)!
        let userDetailFont = UIFont(name: "Avenir-Book", size: 12.0)!
        let userNameAttributes: [NSAttributedStringKey : Any] = [NSAttributedStringKey.foregroundColor: UIColor(hex: "#32083F"), NSAttributedStringKey.font: userNameFont]
        let detailAttributes: [NSAttributedStringKey : Any] = [NSAttributedStringKey.foregroundColor: UIColor(hex: "#32083F"), NSAttributedStringKey.font: userDetailFont]
        
        var string : NSMutableAttributedString = NSMutableAttributedString(string: "")
        if let type = type {
            if (isMine()) {
                switch (type) {
                case .entrySubmitted:
                    string = NSMutableAttributedString(string: "You've submitted an entry for the ", attributes: detailAttributes)
                    if let competitionName = entry?.competition?.title {
                        let aString = NSMutableAttributedString(string: competitionName, attributes: userNameAttributes)
                        string.append(aString)
                    }
                    string.append(NSMutableAttributedString(string: " competition", attributes: detailAttributes))
                    break
                case .entryVotedOn:
                    if let userName = account?.username ?? account?.name {
                        string = NSMutableAttributedString(string: userName, attributes: userNameAttributes)
                    }
                    string.append(NSMutableAttributedString(string: " voted for your entry", attributes: detailAttributes))
                    break
                case .entryCommentedOn:
                    if let userName = account?.username ?? account?.name {
                        string = NSMutableAttributedString(string: userName, attributes: userNameAttributes)
                    }
                    string.append(NSMutableAttributedString(string: " commented on your entry", attributes: detailAttributes))
                    break
                case .entryShared:
                    if let userName = account?.username ?? account?.name {
                        string = NSMutableAttributedString(string: userName, attributes: userNameAttributes)
                    }
                    string.append(NSMutableAttributedString(string: " shared your entry", attributes: detailAttributes))
                    break
                case .ideaVotedOn:
                    if let userName = account?.username ?? account?.name {
                        string = NSMutableAttributedString(string: userName, attributes: userNameAttributes)
                    }
                    string.append(NSMutableAttributedString(string: " voted for your idea", attributes: detailAttributes))
                    break
                    
                case .entryFlagOn:
                    if let userName = account?.username ?? account?.name {
                        string = NSMutableAttributedString(string: userName, attributes: userNameAttributes)
                    }
                    string.append(NSMutableAttributedString(string: " entryFlagOn", attributes: detailAttributes))
                    break
                    
                    
                    
                    
                }
            } else {
                switch (type) {
                case .entrySubmitted:
                    if let userName = account?.username ?? account?.name {
                        string = NSMutableAttributedString(string: userName, attributes: userNameAttributes)
                    }
                    string.append(NSMutableAttributedString(string: " submitted an entry for the ", attributes: detailAttributes))
                    if let competitionName = entry?.competition?.title {
                        let aString = NSMutableAttributedString(string: competitionName, attributes: userNameAttributes)
                        string.append(aString)
                    }
                    string.append(NSMutableAttributedString(string: " competition", attributes: detailAttributes))
                    break
                case .entryVotedOn:
                    if let userName = account?.username ?? account?.name {
                        string = NSMutableAttributedString(string: userName, attributes: userNameAttributes)
                    }
                    string.append(NSMutableAttributedString(string: " voted for ", attributes: detailAttributes))
                    if let entryUserName = entry?.account?.username ?? entry?.account?.name {
                        let aString = NSMutableAttributedString(string: entryUserName, attributes: userNameAttributes)
                        string.append(aString)
                        string.append(NSMutableAttributedString(string: "'s entry in the ", attributes: detailAttributes))
                    }
                    if let competitionName = entry?.competition?.title {
                        let aString = NSMutableAttributedString(string: competitionName, attributes: userNameAttributes)
                        string.append(aString)
                    }
                    string.append(NSMutableAttributedString(string: " competition", attributes: detailAttributes))
                    break
                case .entryCommentedOn:
                    if let userName = account?.username ?? account?.name  {
                        string = NSMutableAttributedString(string: userName, attributes: userNameAttributes)
                    }
                    string.append(NSMutableAttributedString(string:  " commented on ", attributes: detailAttributes))
                    if let entryUserName = entry?.account?.username ?? entry?.account?.name {
                        let aString = NSMutableAttributedString(string: entryUserName, attributes: userNameAttributes)
                        string.append(aString)
                        string.append(NSMutableAttributedString(string: "'s entry in the ", attributes: detailAttributes))
                    }
                    if let competitionName = entry?.competition?.title {
                        let aString = NSMutableAttributedString(string: competitionName, attributes: userNameAttributes)
                        string.append(aString)
                    }
                    string.append(NSMutableAttributedString(string: " competition", attributes: detailAttributes))
                    break
                case .entryShared:
                    if let userName = account?.username ?? account?.name {
                        string = NSMutableAttributedString(string: userName, attributes: userNameAttributes)
                    }
                    string.append(NSMutableAttributedString(string: " shared ", attributes: detailAttributes))
                    if let entryUserName = entry?.account?.username ?? entry?.account?.name {
                        let aString = NSMutableAttributedString(string: entryUserName, attributes: userNameAttributes)
                        string.append(aString)
                        string.append(NSMutableAttributedString(string: "'s entry in the ", attributes: detailAttributes))
                    }
                    if let competitionName = entry?.competition?.title {
                        let aString = NSMutableAttributedString(string: competitionName, attributes: userNameAttributes)
                        string.append(aString)
                    }
                    string.append(NSMutableAttributedString(string: " competition", attributes: detailAttributes))
                    break
                case .ideaVotedOn:
                    if let userName = account?.username ?? account?.name {
                        string = NSMutableAttributedString(string: userName, attributes: userNameAttributes)
                    }
                    string.append(NSMutableAttributedString(string: " voted for ", attributes: detailAttributes))
                    if let entryUserName = entry?.account?.username ?? entry?.account?.name {
                        let aString = NSMutableAttributedString(string: entryUserName, attributes: userNameAttributes)
                        string.append(aString)
                        string.append(NSMutableAttributedString(string: "'s entry in the ", attributes: detailAttributes))
                    }
                    if let competitionName = entry?.competition?.title {
                        let aString = NSMutableAttributedString(string: competitionName, attributes: userNameAttributes)
                        string.append(aString)
                    }
                    if let ideaUserName = idea?.account?.username ?? idea?.account?.name {
                        let aString = NSMutableAttributedString(string: ideaUserName, attributes: userNameAttributes)
                        string.append(aString)
                        string.append(NSMutableAttributedString(string: "'s idea", attributes: detailAttributes))
                    }
                    break
                case .entryFlagOn:
                    if let userName = account?.username ?? account?.name {
                        string = NSMutableAttributedString(string: userName, attributes: userNameAttributes)
                    }
                    string.append(NSMutableAttributedString(string: " entryFlagOn ", attributes: detailAttributes))
                    if let entryUserName = entry?.account?.username ?? entry?.account?.name {
                        let aString = NSMutableAttributedString(string: entryUserName, attributes: userNameAttributes)
                        string.append(aString)
                        string.append(NSMutableAttributedString(string: "'s entry in the ", attributes: detailAttributes))
                    }
                    if let competitionName = entry?.competition?.title {
                        let aString = NSMutableAttributedString(string: competitionName, attributes: userNameAttributes)
                        string.append(aString)
                    }
                    if let ideaUserName = idea?.account?.username ?? idea?.account?.name {
                        let aString = NSMutableAttributedString(string: ideaUserName, attributes: userNameAttributes)
                        string.append(aString)
                        string.append(NSMutableAttributedString(string: "'s idea", attributes: detailAttributes))
                    }
                    break
                    
                    
                    
                }
            }
        }
        return string
    }
}





