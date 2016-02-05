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
    
    static func sendPictureRequest() {
        log("=======================")
        log("button pressed")
        
        if WCSession.isSupported() {
            let session = WCSession.defaultSession()
            
            log("requesting picture")
            
            // updateApplicationContext - background request for a picture to be taken
            do {
                try session.updateApplicationContext([WatchConstants.takePictureCommand: "NOW"])
            } catch {
                log("\(error)")
            }
        }
    }
    
    static func log (message : String) {
        print(message)
        let root = WKExtension.sharedExtension().rootInterfaceController as? InterfaceController
        root?.button.setTitle(message)

    }

}
