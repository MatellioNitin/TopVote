//
//  PFComment.swift
//  TopVote
//
//  Created by Kurt Jensen on 3/2/16.
//  Copyright © 2016 TopVote. All rights reserved.
//

import UIKit
import Parse

class PFComment: PFObject, PFSubclassing {
    
    @NSManaged var entry: PFEntry!
    @NSManaged var user: PFVoter!
    @NSManaged var text: String
    
    class func parseClassName() -> String {
        return "Comment"
    }
    
    convenience init(entry: PFEntry, text: String) {
        self.init()
        self.entry = entry
        self.user = PFVoter.current()!
        self.text = text
    }
    
    class func queryWithIncludes() -> PFQuery<PFObject>? {
        let query = PFComment.query()
        query?.includeKey("user")
        return query
    }
    
}
