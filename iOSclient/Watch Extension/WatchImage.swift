//
//  WatchImage.swift
//  doorbell
//
//  Created by Dennis Schultz on 1/22/16.
//  Copyright © 2016 Dennis Schultz. All rights reserved.
//

import Foundation
import UIKit

// Represents a picture and related metadata
class WatchImage {

    let date : String!
    let image : UIImage!
    
    init (date: String, imageData: NSData) {
        self.date = date
        self.image = UIImage(data: imageData)
    }
    
}