//
//  PFFlag.swift
//  TopVote
//
//  Created by Kurt Jensen on 3/2/16.
//  Copyright © 2016 TopVote. All rights reserved.
//

import UIKit
import Parse

class PFFlag: PFObject, PFSubclassing {
    
    @NSManaged var entry: PFEntry!
    @NSManaged var user: PFVoter!
    @NSManaged var status: Int
    
    class func parseClassName() -> String {
        return "Flag"
    }
    
    convenience init(entry: PFEntry) {
        self.init()
        self.entry = entry
        self.user = PFVoter.current()!
        self.status = 0
    }
    
}
