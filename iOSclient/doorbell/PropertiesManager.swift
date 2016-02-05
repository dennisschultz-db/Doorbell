//
//  PropertiesManager.swift
//  doorbell
//
//  Created by Dennis Schultz on 11/10/15.
//  Copyright © 2015 Dennis Schultz. All rights reserved.
//

import Foundation

let configurationPath = NSBundle.mainBundle().pathForResource("doorbell", ofType: "plist")
let configuration = NSDictionary(contentsOfFile: configurationPath!)

