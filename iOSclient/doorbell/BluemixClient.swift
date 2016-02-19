//
//  BluemixClient.swift
//  doorbell
//
//  Created by Dennis Schultz on 9/1/15.
//  Copyright (c) 2015 Dennis Schultz. All rights reserved.
//
import Foundation
import UIKit

class BluemixClient: NSObject {
   
    let logger = IMFLogger(forName: "BluemixClient")
    
    private let pushService: IMFPushClient?
    private var myToken: NSData?

    override init() {
        
        let bluemixRoute = configuration?["Bluemix"]!["Route"] as! String
        let bluemixGUID = configuration?["Bluemix"]!["GUID"] as! String

        // Initialize the connection to Bluemix services
        IMFClient.sharedInstance().initializeWithBackendRoute(
            bluemixRoute,
            backendGUID: bluemixGUID)
        self.pushService = IMFPushClient.sharedInstance()
        
    }
    
    // ===========================================================================
    ///  Registers the device with IBM Bluemix Push Notifications
    ///
    ///  - parameters:
    ///    - token : Token returned when the device successfully registered with APNS.
    func registerForPush (token: NSData) {
        self.myToken = token
        if (self.pushService != nil)  {
            pushService?.registerDeviceToken(token, completionHandler: { (response, error) -> Void in
                if error != nil {
                    self.logger.logErrorWithMessages("IBM Push Registration Failure...")
                    return
                }
            })
            
        } else {
            logger.logErrorWithMessages("Push service is nil")
        }
        
    }

    
    // ===========================================================================
    ///  Subscribes the device to the given tag.
    ///
    ///  Currently unused.
    ///
    ///  - parameters:
    ///    - tag : Tag to subscribe
    func application(application: UIApplication, subscribeToTag tag : String) {
        pushService!.subscribeToTags([tag], completionHandler: {(response,error) -> Void in
            if (error != nil) {
                self.logger.logErrorWithMessages("Failure during tag subscription")
                self.logger.logErrorWithMessages(error.description)
            } else {
                self.logger.logInfoWithMessages("Successfully subscribed to tag: ")
                self.logger.logInfoWithMessages(response.description)
            }
        })
        
    }

}
