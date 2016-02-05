//
//  Uitls.swift
//  doorbell
//
//  Created by Dennis Schultz on 1/19/16.
//  Copyright © 2016 Dennis Schultz. All rights reserved.
//

import Foundation
import UIKit
import WatchConnectivity

class WatchUtils: NSObject {
    
    static func transferPictureToWatch(picture: Picture) {
        print("building file")
        
        let fm = NSFileManager()
        let url = try! fm.URLForDirectory(.CachesDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true).URLByAppendingPathComponent(WatchConstants.fileName)
        
        picture.getWatchImageData()?.writeToURL(url, atomically: true)
        
        print("sending picture")
        // Send the image and date string to Watch

        let metadata = [
            WatchConstants.statusMetadataKey: "success",
            WatchConstants.fileNameMetadataKey: WatchConstants.fileName,
            WatchConstants.dateMetadataKey: picture.date]
        
        let session = WCSession.defaultSession()
        session.transferFile(url, metadata: metadata)
    }

}
