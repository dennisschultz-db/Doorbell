//
//  MQTTClient.swift
//  doorbell
//
//  Created by Dennis Schultz on 12/7/15.
//  Copyright © 2015 Dennis Schultz. All rights reserved.
//

import Foundation
import UIKit

class MQTTDoorbellClient: NSObject {

    let logger = IMFLogger(forName: "MQTTDoorbellClient")

    // IoT connection parameters extracted from doorbell.plist
    let ioTHostBase = configuration?["IoT"]!["HostBase"] as! String
    let ioTAPIKey = configuration?["IoT"]!["APIKey"] as! String
    let ioTAuthenticationToken = configuration?["IoT"]!["AuthenticationToken"] as! String
    let orgId = configuration?["IoT"]!["OrgID"] as! String
    let deviceType = configuration?["IoT"]!["DeviceType"] as! String
    let deviceID = configuration?["IoT"]!["DeviceID"] as! String

    // Command and event strings that will be constructed in the init()
    let startStreamCommand: String?
    let stopStreamCommand: String?
    let takePictureCommand: String?
    let streamStartedEvent: String?
    let streamStoppedEvent: String?
    let pictureTakenEvent: String?

    // callbacks provided by the caller when invoking a command
    var streamCompletionHandler: ((String) -> Void)?
    var pictureCompletionHandler: ((AnyObject) -> Void)?

    // Maintains instance of session with IoT Foundation
    private var iotfSession :MQTTSessionManager?
    
    
    /** Initializer.  Creates the IoT Foundation connection
     
     */
    override init() {
        
        startStreamCommand = "iot-2/type/" + deviceType + "/id/" + deviceID + "/cmd/startStream/fmt/json"
        stopStreamCommand  = "iot-2/type/" + deviceType + "/id/" + deviceID + "/cmd/stopStream/fmt/json"
        
        streamStartedEvent = "iot-2/type/" + deviceType + "/id/" + deviceID + "/evt/streamStarted/fmt/json"
        streamStoppedEvent = "iot-2/type/" + deviceType + "/id/" + deviceID + "/evt/streamStopped/fmt/json"
        
        takePictureCommand = "iot-2/type/" + deviceType + "/id/" + deviceID + "/cmd/takePicture/fmt/json"
        pictureTakenEvent  = "iot-2/type/" + deviceType + "/id/" + deviceID + "/evt/pictureTaken/fmt/json"
        

        super.init()
        
        iotfSession = MQTTSessionManager()
        iotfSession!.delegate = self

    }
    
    
    // ===========================================================================
    ///  Creates a connection to the IoT Foundation and subscribes to the events 
    ///  that will come from the Raspberry Pi.
    func connect() {

        if (iotfSession == nil || iotfSession?.state != MQTTSessionManagerState.Connected) {
            
            let host = orgId + "." + ioTHostBase
            let clientId = "a:" + orgId + ":" + ioTAPIKey

            iotfSession?.connectTo(
                host,
                port: 1883,
                tls: false,
                keepalive: 30,
                clean: true,
                auth: true,
                user: ioTAPIKey,
                pass: ioTAuthenticationToken,
                will: false,
                willTopic: nil,
                willMsg: nil,
                willQos: MQTTQosLevel.AtMostOnce,
                willRetainFlag: false,
                withClientId: clientId)
            
            while iotfSession!.state != MQTTSessionManagerState.Connected {
                NSRunLoop.currentRunLoop().runUntilDate(NSDate(timeIntervalSinceNow: 1))
            }

            iotfSession!.subscriptions = [streamStartedEvent!: 2, streamStoppedEvent!: 2, pictureTakenEvent!: 2]
            
        }
    }
    
    // ===========================================================================
    ///  Dsiconnects from the IoT Foundation.
    func disconnect() {
        iotfSession!.disconnect()
    }
    
    // ===========================================================================
    ///  Sends the command to the Pi via IoT Foundation (MQTT)
    ///
    ///  - parameters:
    ///    - completion : Completion handler that will be invoked when the command completes.
    func sendStartStreamCommand(completion: (String) -> Void) {
        
        logger.logInfoWithMessages("Sending startStream command")

        connect()
        
        let dictionary = ["message": "Hello, Pi!"]
        
        iotfSession!.sendData(
            createMessage(dictionary),
            topic: startStreamCommand,
            qos: MQTTQosLevel.ExactlyOnce,
            retain: false)
        
        streamCompletionHandler = completion
            
    }

    
    // ===========================================================================
    ///  Sends the command to the Pi via IoT Foundation (MQTT)
    ///
    ///  - parameters:
    ///    - completion : Completion handler that will be invoked when the command completes.
    func sendStopStreamCommand(completion: ((String) -> Void)?) {
        
        logger.logInfoWithMessages("Sending stopStream command")
        
        connect()
        
        let dictionary = ["message": "Hello, Pi!"]
        
        iotfSession!.sendData(
            createMessage(dictionary),
            topic: stopStreamCommand,
            qos: MQTTQosLevel.ExactlyOnce,
            retain: false)
        
        streamCompletionHandler = completion
        
    }
    
    // ===========================================================================
    ///  Sends the command to the Pi via IoT Foundation (MQTT)
    ///
    ///  - parameters:
    ///    - completion : Completion handler that will be invoked when the command completes.
    func sendTakePictureCommand(completion: (AnyObject) -> Void) {
        
        logger.logInfoWithMessages("Sending takePicture command")
        
        connect()
        
        let dictionary = ["message": "Hello, Pi!"]
        
        iotfSession!.sendData(
            createMessage(dictionary),
            topic: takePictureCommand,
            qos: MQTTQosLevel.ExactlyOnce,
            retain: false)
        
        pictureCompletionHandler = completion
        
    }
    
    /**
     utility method to create a message suitable for publication from a Dictionary

     - Parameters:
       - message: a message in the form of a dictionary
     
     - Returns: an NSData object
    */
    func createMessage (message: Dictionary<String, String>) -> NSData? {
        do {
        let theJSONData = try NSJSONSerialization.dataWithJSONObject(
            message,
            options: NSJSONWritingOptions(rawValue: 0))
        
        let theJSONText = NSString(data: theJSONData,
            encoding: NSASCIIStringEncoding)
        
        return (theJSONText?.dataUsingEncoding(NSUTF8StringEncoding))!
            
        } catch {
            return nil
        }
    }
}


// MARK: Extensions

extension MQTTDoorbellClient: MQTTSessionManagerDelegate {
    
    // ===========================================================================
    ///  Called each time a message (event) is received.
    ///
    ///  - parameters:
    ///    - data : Data sent along with the event
    ///    - topic : Topic on which the message was received
    ///    - retained: Indicates if the message should be retained on the broker
    func handleMessage(data: NSData!, onTopic topic: String!, retained: Bool) {

        logger.logInfoWithMessages("Received newMessage on: \(topic)")

        
       do {
            let obj = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)
            
            switch topic {
            case streamStartedEvent!:
                let ipAddress = obj["piIpAddress"] as? String
                
                // Invoke callback that sets IP address in UI
                if let callback = self.streamCompletionHandler {
                    callback(ipAddress!)
                }
                
            case streamStoppedEvent!:
                if let callback = self.streamCompletionHandler {
                    callback(dummyIPAddress)
                }
                
            case pictureTakenEvent!:
                if let callback = self.pictureCompletionHandler {
                    callback(obj)
                }
                
            default:
                logger.logInfoWithMessages("Unrecognized topic \(topic)" )
                
            }
            
        } catch {
            logger.logInfoWithMessages("Could not convert message data")
        }
        
    }
    
}
