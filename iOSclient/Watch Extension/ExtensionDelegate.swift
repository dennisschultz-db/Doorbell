//
//  ExtensionDelegate.swift
//  Watch Extension
//
//  Created by Dennis Schultz on 1/15/16.
//  Copyright © 2016 Dennis Schultz. All rights reserved.
//

import WatchKit
import WatchConnectivity
import Foundation

class ExtensionDelegate: NSObject {

    var root: InterfaceController!
    
    // MARK: - Watch Connectivity
    
    private func setupWatchConnectivity() {
        if WCSession.isSupported() {
            let session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
    }

}

extension ExtensionDelegate: WKExtensionDelegate {
    
    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
        setupWatchConnectivity()
        root = WKExtension.sharedExtension().rootInterfaceController as? InterfaceController
    }
    
    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }
    
    func handleActionWithIdentifier(identifier: String?, forRemoteNotification remoteNotification: [NSObject : AnyObject]) {
        // Called when user selects a custom notification action button as a result of a
        // Push notification from the Raspberry Pi.
        
        // Note that actions will only be handled by the Watch if the iPhone is not active,
        // otherwise, the notification will be presented on the iPhone.
        print("handleActionWithIdentifier with identifier = " + identifier!)

        // Set the current user activity for Handoff based on which
        // custom action button was tapped
        root = WKExtension.sharedExtension().rootInterfaceController as? InterfaceController
        if identifier == "picture" {
            root!.updateUserActivity(
                Handoff.ActivityType.ViewPicture.rawValue,
                userInfo: [Handoff().activityValueKey:"Push"],
                webpageURL: nil)
        } else if identifier == "video" {
            root!.updateUserActivity(
                Handoff.ActivityType.ViewVideo.rawValue,
                userInfo: [Handoff().activityValueKey:"Push"],
                webpageURL: nil)
        }
    }
}


extension ExtensionDelegate: WCSessionDelegate {
    
    func session(session: WCSession, didReceiveFile file: WCSessionFile) {
        // Called when the iPhone sends an image file to the Watch
        root = WKExtension.sharedExtension().rootInterfaceController as? InterfaceController
        guard let metadata = file.metadata where metadata[WatchConstants.statusMetadataKey] is String else {
                root?.button.setTitle("No metadata")
                return
        }
        
        let status = metadata[WatchConstants.statusMetadataKey] as! String
        if status == "success" {
            let imageData = NSData(contentsOfURL: file.fileURL)
            
            // Format a human readable date string
            let formatter = NSDateFormatter()
            formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            formatter.timeStyle = .ShortStyle
            let pictureDate = formatter.stringFromDate((metadata[WatchConstants.dateMetadataKey] as? NSDate)!)
            
            // Create a WatchImage instance and pass it as context to the interface controller
            let watchImage = WatchImage(date: pictureDate, imageData: imageData!)
            
            dispatch_async(dispatch_get_main_queue()) {
                () -> Void in
                WKInterfaceController.reloadRootControllersWithNames(["picture"], contexts: [watchImage])
            }
            
        } else {
            // Status other than success
            root?.button.setTitle(status)
            
        }
        
    }

}

