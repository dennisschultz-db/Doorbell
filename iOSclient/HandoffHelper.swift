//
//  HandoffHelper.swift
//  doorbell
//
//  Created by Dennis Schultz on 1/28/16.
//  Copyright © 2016 Dennis Schultz. All rights reserved.
//

import Foundation

struct Handoff {
    enum ActivityType: String {
        case ViewPicture = "com.ibm.dws.doorbell.picture"
        case ViewVideo =   "com.ibm.dws.doorbell.video"
    }
    
    let activityValueKey = "ActivityValue"
}