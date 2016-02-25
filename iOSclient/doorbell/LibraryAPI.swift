//
//  LibraryAPI.swift
//  doorbell
//
//  Created by Dennis Schultz on 9/1/15.
//  Copyright (c) 2015 Dennis Schultz. All rights reserved.
//
import Foundation

// Wrapper for the MQTT, Cloudant and Bluemix APIs
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
    
    // ===========================================================================
    ///  Registers for push notifications from the IBM Bluemix Push Notifications service.
    ///
    ///  - parameters:
    ///    - token : Token returned when the device successfully registered with APNS.
    func registerForPush(token: NSData) {
        bluemix.registerForPush(token)
    }
    
    // ===========================================================================
    ///  Sends the command to the Pi via IoT Foundation (MQTT)
    ///
    ///  - parameters:
    ///    - completion : Completion handler that will be invoked when the command completes.
    func sendStartStreamCommand(completion: (String) -> Void) {
        mqtt.sendStartStreamCommand(completion)
    }
    
    // ===========================================================================
    ///  Sends the command to the Pi via IoT Foundation (MQTT)
    ///
    ///  - parameters:
    ///    - completion : Completion handler that will be invoked when the command completes.
    func sendStopStreamCommand(completion: ((String) -> Void)?) {
        mqtt.sendStopStreamCommand(completion)
    }
    
    // ===========================================================================
    ///  Sends the command to the Pi via IoT Foundation (MQTT)
    ///
    ///  - parameters:
    ///    - completion : Completion handler that will be invoked when the command completes.
    func sendTakePictureCommand(completion: (AnyObject) -> Void) {
        mqtt.sendTakePictureCommand(completion)
    }

    // ===========================================================================
    ///  Performs all the steps necessary to have the Pi take a picture and send it back.
    ///
    ///  - parameters:
    ///    - statusUpdate : callback that provides ongoing status updates
    ///    - completion: callback that provides the completed picture
    func takePicture(statusUpdate: (String) -> Void, completion: (String?, Picture) -> Void) {

        var picture : Picture = Picture(name: "temp", date: NSDate())
        
        LibraryAPI.sharedInstance.sendTakePictureCommand() {
            (packet: AnyObject) in
            
            let picId = packet["pic_id"] as! String
            let data  = packet["data"] as! String
            let pos   = packet["pos"] as! Int
            let total = packet["size"]as! Int
            
            logger.logInfoWithMessages("Packet " + String(pos) + "/" + String(total) + " of file " + picId)
            statusUpdate("Retrieving picture... \(pos) of \(total)")
        
            // Initialize picture if this is the first packet
            if pos == 0 {
                let timestamp = packet["pic_date"] as! Double
                picture = Picture(name: picId, date: NSDate(timeIntervalSince1970: timestamp / 1000.0))
            }
            
            // finalize the picture and call completion handler if this is the last packet
            if pos == total - 1 {
                logger.logInfoWithMessages("Got all packets")
                picture.addPacket(data, finalPacket: true)
                                
                completion(nil, picture)
                
            } else {
                picture.addPacket(data, finalPacket: false)
            }
        }
    }
    

    // ===========================================================================
    ///  Retrieves a picture from Cloudant
    ///
    ///  - parameters:
    ///    - pictureId : _id of the document in the database
    ///    - completion: callback that provides the completed picture
    func retrievePicture(pictureId : String, completion: (String?, Picture) -> Void) {
        
        cloudant.retrievePicture(pictureId, completion: completion)
        
    }

    // ===========================================================================
    ///  Retrieves a list of pictures from Cloudant
    ///
    ///  - parameters:
    ///    - completion: callback that provides the completed picture
    func retrievePictureList(completion: (String?, [String]) -> Void) {
        
        cloudant.retrievePictureList(completion)
        
    }

}
