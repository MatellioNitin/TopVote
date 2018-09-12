//
//  Video+Audio.swift
//  Topvote
//
//  Created by Benjamin S. Stahlhood II on 10/24/17.
//  Copyright © 2017 Top, Inc. All rights reserved.
//

import Foundation

extension Media {
    struct AudioInfo: ModelGenerator {
        // MARK: - Properties
        
        var codec: String?
        
        var bit_rate: String?
        
        var frequency: Double?
        
        var channels: Int?
        
        var channel_layout: String?
    }
}
