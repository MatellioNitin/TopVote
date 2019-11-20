//
//  Video+Info.swift
//  Topvote
//
//  Created by Benjamin S. Stahlhood II on 10/24/17.
//  Copyright © 2017 Top, Inc. All rights reserved.
//

import Foundation

extension Media {
    struct VideoInfo: ModelGenerator {
        // MARK: - Properties
        
        var pix_format: String?
        
        var codec: String?
        
        var level: Double?
        
        var bit_rate: String?
    }
}
