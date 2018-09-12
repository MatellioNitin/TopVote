//
//  PFVoter.swift
//  TopVote
//
//  Created by Kurt Jensen on 3/1/16.
//  Copyright © 2016 TopVote. All rights reserved.
//

import UIKit
import Parse
import ParseFacebookUtilsV4
import SwiftyJSON

class PFVoter: PFUser {
    
    @NSManaged var instagramId: String?
    @NSManaged var facebookId: String?
    @NSManaged var twitterId: String?
    @NSManaged var imageURL: String?

    @NSManaged var name: String?
    @NSManaged var bio: String?
    @NSManaged var location: PFGeoPoint?
    @NSManaged var locationName: String?
    @NSManaged var ageRange: String?
    @NSManaged var gender: String?

    @NSManaged var followerIds: [String]?
    @NSManaged var followingIds: [String]?
    @NSManaged var numberCompetitionsWon: Int
    @NSManaged var numberCompetitionsEntered: Int
    @NSManaged var numberVotesReceived: Int
    @NSManaged var valueVotesReceived: Int
    @NSManaged var numberVotesGiven: Int
    @NSManaged var valueVotesGiven: Int
    @NSManaged var numberSharesReceived: Int
    @NSManaged var numberSharesGiven: Int
    @NSManaged var numberProfileViews: Int

    convenience init(username: String, password: String, email: String) {
        self.init()
        self.username = username
        self.password = password
        self.email = email
    }
    
    func needsProfileFix() -> Bool {
        return name == nil || bio == nil || username == nil || imageURL == nil
    }
    
    func profileError() -> String? {
        if (name == nil || name?.characters.count == 0) {
            return "Please enter a name"
        } else if (bio == nil) {
            return "Please enter a bio"
        } else if (username == nil || username?.characters.count == 0) {
            return "Please enter a username"
        } else if (imageURL == nil) {
            return "Please upload a profile image"
        }
        return nil
    }
    
    func isFollowing(_ user: PFVoter) -> Bool? {
        if let userId = user.objectId, let followingIds = followingIds {
            return followingIds.contains(userId)
        }
        return nil
    }
    
    func toggleFollowing(_ user: PFVoter) {
        if let isFollowing = isFollowing(user) {
            if (isFollowing) {
                let _ = unfollow(user)
            } else {
                let _ = follow(user)
            }
        }
    }

    func follow(_ user: PFVoter) -> Bool {
        if let userId = user.objectId {
            if (self.objectId != userId) {
                self.addUniqueObject(userId, forKey: "followingIds")
                do {
                    try self.save()
                    return true
                } catch {
                }
            }
        }
        return false
    }
    
    func unfollow(_ user: PFVoter) -> Bool {
        if let userId = user.objectId {
            if (self.objectId != userId) {
                self.remove(userId, forKey: "followingIds")
                do {
                    try self.save()
                    return true
                } catch {
                }
            }
        }
        return false
        
    }
    
    class func usersForIdsQuery(_ userIds: [String]) -> PFQuery<PFObject>? {
        let query = PFVoter.query()
        query?.whereKey("objectId", containedIn: userIds)
        return query
    }
    
    // REFRESH
    
    func refreshData(_ completion: @escaping () -> Void) {
        if let userId = objectId {
            PFVoter.query()?.getObjectInBackground(withId: userId, block: { (user, error) -> Void in
                if let user = user as? PFVoter {
                    self.followerIds = user.followerIds
                    self.followingIds = user.followingIds
                    self.numberCompetitionsWon = user.numberCompetitionsWon
                    self.numberCompetitionsEntered = user.numberCompetitionsEntered
                    self.numberVotesReceived = user.numberVotesReceived
                    self.valueVotesReceived = user.valueVotesReceived
                    self.numberVotesGiven = user.numberVotesGiven
                    self.valueVotesGiven = user.valueVotesGiven
                    self.numberSharesReceived = user.numberSharesReceived
                    self.numberSharesGiven = user.numberSharesGiven
                    self.numberProfileViews = user.numberProfileViews
                }
                completion()
            })
        }
    }
    
    // SETUP
    
    func setup(_ completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        if (followerIds == nil) { followerIds = [] }
        if (followingIds == nil) { followingIds = [] }
        fetchFacebookInfoIfNeeded(completion)
    }
    
    func fetchFacebookInfoIfNeeded(_ completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        
        if PFFacebookUtils.isLinked(with: self) {
            
            let requestParameters = ["fields": "id, email, first_name, last_name"]
            let userDetails = FBSDKGraphRequest(graphPath: "me", parameters: requestParameters)
            let _ = userDetails?.start(completionHandler: { (connection, result, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                if let result = result {
                    let json = JSON(result)
                    if let userId = json["id"].string {
                        self.facebookId = userId
                        self.imageURL = "https://graph.facebook.com/\(userId)/picture?type=large"
                    }
                    var name = ""
                    if let userFirstName = json["first_name"].string {
                        name += userFirstName
                    }
                    if let userLastName = json["last_name"].string {
                        name += " " + userLastName
                    }
                    self.name = name
                    
                    if let userEmail = json["email"].string {
                        //self.email = userEmail
                    }
                    self.saveInBackground(block: { (success, error) in
                        completion(success, error)
                    })
                }
            })
        } else {
            self.saveInBackground(block: { (success, error) in
                completion(success, error)
            })
        }
        
    }
    
}
