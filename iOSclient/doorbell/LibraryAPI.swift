//
//  LibraryAPI.swift
//  doorbell
//
//  Created by Dennis Schultz on 9/1/15.
//  Copyright (c) 2015 Dennis Schultz. All rights reserved.
//
import Foundation

// Wrapper for the MQTT and Bluemix APIs
class LibraryAPI: NSObject {
    
    private let bluemix : BluemixClient
    private let mqtt    : MQTTDoorbellClient
    private let cloudant: CloudantClient

    // Implements Singleton pattern
    class var sharedInstance: LibraryAPI {
        struct Singleton {
            static let instance = LibraryAPI()
        }
        return Singleton.instance
    }

    override init() {
        bluemix = BluemixClient()
        mqtt = MQTTDoorbellClient()
        cloudant = CloudantClient()

        super.init()
    }
    
    func registerForPush(token: NSData) {
        bluemix.registerForPush(token)
    }
    
    func sendStartStreamCommand(completion: (String) -> Void) {
        mqtt.sendStartStreamCommand(completion)
    }
    
    func sendStopStreamCommand(completion: ((String) -> Void)?) {
        mqtt.sendStopStreamCommand(completion)
    }
    
    func sendTakePictureCommand(completion: (AnyObject) -> Void) {
        mqtt.sendTakePictureCommand(completion)
    }

    // Performs all the steps necessary to have the Pi take a picture
    // and send it back.
    // statusUpdate - callback that provides ongoing status updates
    // completion - callback that provides the completed picture
    func takePicture(statusUpdate: (String) -> Void, completion: (Picture) -> Void) {

        var picture : Picture = Picture(name: "temp", date: NSDate())
        
        LibraryAPI.sharedInstance.sendTakePictureCommand() {
            (packet: AnyObject) in
            
            let picId = packet["pic_id"] as! String
            let data  = packet["data"] as! String
            let pos   = packet["pos"] as! Int
            let total = packet["size"]as! Int
            
            logger.logInfoWithMessages("Packet " + String(pos) + "/" + String(total) + " of file " + picId)
            statusUpdate("Retrieving picture...")
        
            // Initialize picture if this is the first packet
            if pos == 0 {
                let timestamp = packet["pic_date"] as! Double
                picture = Picture(name: picId, date: NSDate(timeIntervalSince1970: timestamp / 1000.0))
            }
            
            // finalize the picture and call completion handler if this is the last packet
            if pos == total - 1 {
                logger.logInfoWithMessages("Got all packets")
                picture.addPacket(data, finalPacket: true)
                                
                completion(picture)
                
            } else {
                picture.addPacket(data, finalPacket: false)
            }
        }
    }
    
    func retrievePicture(pictureId : String, completion: (Picture) -> Void) {
        
        cloudant.retrievePicture(pictureId, completion: completion)
        
    }
}
