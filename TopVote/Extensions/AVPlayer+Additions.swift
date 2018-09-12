//
//  AVPlayer+Additions.swift
//  iOS Foundation
//
//  Created by Luke McDonald on 5/29/17.
//  Copyright © 2017 Luke McDonald. All rights reserved.
//

import Foundation
import AVFoundation

extension AVPlayer {
    var isPlaying: Bool {
        return ((rate != 0) && (error == nil))
    }
}
