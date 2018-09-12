//
//  PFCompetition.swift
//  TopVote
//
//  Created by Kurt Jensen on 3/1/16.
//  Copyright © 2016 TopVote. All rights reserved.
//

import UIKit
import Parse

class PFCompetition: PFObject, PFSubclassing {

    @NSManaged var title: String?
    @NSManaged var text: String?
    @NSManaged var type: Int
    @NSManaged var imageURL: String?
    @NSManaged var byImageURL: String?
    //@NSManaged var startDate: NSDate?
    @NSManaged var endDate: Date
    @NSManaged var isFeatured: Bool
    @NSManaged var byText: String?
    @NSManaged var winner: PFEntry?
    @NSManaged var isLocalized: Bool
    @NSManaged var location: PFGeoPoint
    @NSManaged var status: Int

    class func parseClassName() -> String {
        return "Competition"
    }
    
    func hasEnded() -> Bool {
        return status != 0
    }
    
    func timeRemainingString() -> String {
        var string = ""
        let days = (endDate.timeIntervalSinceNow / 86400)
        let hours = endDate.timeIntervalSinceNow.truncatingRemainder(dividingBy: 86400) / 3600
        let minutes = 0 // TODO(endDate.timeIntervalSinceNow % 86400).truncatingRemainder(dividingBy: 3600) / 60
        string = String(format: "%dd %dh %dm", arguments: [Int(days), Int(hours), Int(minutes)])
        return string
    }
    
    func winnerString() -> String {
        var string = ""
        string = "Won by "
        if let winnerName = winner?.user?.username ?? winner?.user?.name {
            string += winnerName
        }
        return string
    }
    
    class func queryWithIncludes() -> PFQuery<PFObject>? {
        let query = PFCompetition.query()
        query?.includeKey("winner")
        query?.includeKey("winner.user")
        query?.includeKey("winner.entry")
        return query
    }

    class func homeGlobalQuery() -> PFQuery<PFObject>? {
        let globalQuery = PFCompetition.queryWithIncludes()
        globalQuery?.whereKey("status", equalTo: 0)
        globalQuery?.whereKey("isLocalized", equalTo: false)
        return globalQuery
    }
    
    class func hallOfFameQuery() -> PFQuery<PFObject>? {
        let query = PFCompetition.queryWithIncludes()
        query?.whereKey("status", equalTo: 1)
        query?.order(byDescending: "isFeatured,endDate")
        return query
    }
    
    class func competitionsForUserQuery(_ user: PFUser) -> PFQuery<PFObject>? {
        if let entryQuery = PFEntry.entriesForUserQuery(user) {
            let query = PFCompetition.queryWithIncludes()
            query?.whereKey("objectId", matchesKey:"competitionId", in: entryQuery)
            return query
        }
        return nil
    }
    
}
