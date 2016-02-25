//
//  CommunicationManager.swift
//  doorbell
//
//  Created by Dennis Schultz on 1/25/16.
//  Copyright © 2016 Dennis Schultz. All rights reserved.
//

import WatchKit
import WatchConnectivity

class CommunicationManager: NSObject {
    
    // ===========================================================================
    ///  Sends a request to the phone for a picture.
    ///
    static func sendPictureRequest() {
        log("button pressed")
        
        if WCSession.isSupported() {
            let session = WCSession.defaultSession()
            
            log("Requesting picture...")
            
            // updateApplicationContext - background request for a picture to be taken
            do {
                session.sendMessage([WatchConstants.takePictureCommand: "NOW"],replyHandler: nil, errorHandler: nil)
                try session.updateApplicationContext([WatchConstants.takePictureCommand: "NOW"])
            } catch {
                log("\(error)")
            }
        }
    }
    
    // ===========================================================================
    ///  Sends a request to the phone for a picture from Cloudant.
    ///
    static func sendCloudantPictureRequest(pictureId: String) {
        log("Fetching picture...")
        
        if WCSession.isSupported() {
            let session = WCSession.defaultSession()
            
            // updateApplicationContext - background request for a picture to be taken
            do {
                session.sendMessage([WatchConstants.getCloudantPictureCommand: pictureId],replyHandler: nil, errorHandler: nil)
//                try session.updateApplicationContext([WatchConstants.getCloudantPictureCommand: pictureId])
            } catch {
                log("\(error)")
            }
        }
    }
    
    // ===========================================================================
    ///  Logs the given message in the console and in the status area of the UI
    ///
    static func log (message : String) {
        print(message)
        let root = WKExtension.sharedExtension().rootInterfaceController as? InterfaceController
        root?.button.setTitle(message)

    }

}
