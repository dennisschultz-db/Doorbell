//
//  AppDelegate.swift
//  doorbell
//
//  Created by Dennis Schultz on 8/20/15.
//  Copyright (c) 2015 Dennis Schultz. All rights reserved.
//

import UIKit
import CoreData
import AVKit
import AVFoundation
import WatchConnectivity

let logger = IMFLogger(forName: "Doorbell")

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    static var vvc: VideoViewController?
    static var pvc: PictureViewController?
    var avPlayer: AVAudioPlayer?
    
    // Prevents view initialization from happening twice
    var wasLaunchedFromAction = false
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        application.applicationIconBadgeNumber = 0
        
        // Register for push notifications
        registerUserNotificationSettings()
        
        // Setup Bluemix logging preferences
        IMFLogger.captureUncaughtExceptions() // capture and record uncaught exceptions (crashes)
        IMFLogger.setLogLevel(IMFLogLevel.Debug) // change the verbosity filter to "debug and above"
        IMFAnalytics.sharedInstance().startRecordingApplicationLifecycleEvents() // automatically record app startup times and foreground/background events
        
        // Initialize the LibraryAPI
        LibraryAPI.sharedInstance

        // Setup connection to Watch
        setupWatchConnectivity()
        
        return true
    }
    
    private func setupWatchConnectivity() {
        if (WCSession.isSupported()) {
            print("WCSession is Supported")
            let session = WCSession.defaultSession()
            session.delegate = self;
            session.activateSession()
        }
        
        if WCSession.defaultSession().watchAppInstalled {
            print("watchAppInstalled")
        }
    }

    private func registerUserNotificationSettings() {
        // Register for push in iOS 8 and above
        // Actionable Notifications
        let videoAction = UIMutableUserNotificationAction()
        videoAction.title = NSLocalizedString("Video", comment: "Launch Video")
        videoAction.identifier = "video"
        videoAction.activationMode = UIUserNotificationActivationMode.Foreground
        videoAction.authenticationRequired = false
        
        let pictureAction = UIMutableUserNotificationAction()
        pictureAction.title = NSLocalizedString("Picture", comment: "Launch Picture")
        pictureAction.identifier = "picture"
        pictureAction.activationMode = UIUserNotificationActivationMode.Foreground
        pictureAction.authenticationRequired = false
        
        let actionCategory = UIMutableUserNotificationCategory()
        actionCategory.setActions([videoAction, pictureAction],
            forContext: UIUserNotificationActionContext.Default)
        actionCategory.identifier = "doorbell"
        
        let categories = NSSet(array: [actionCategory])
        
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: categories as? Set<UIUserNotificationCategory>)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        UIApplication.sharedApplication().registerForRemoteNotifications()

    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        LibraryAPI.sharedInstance.sendStopStreamCommand(nil)
        
        IMFLogger.send() // send all IMFLogger logged data to the server
        IMFAnalytics.sharedInstance().sendPersistedLogs() // send all analytics data to the server

    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        logger.logInfoWithMessages("applicationWillEnterForeground")
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        logger.logInfoWithMessages("applicationDidBecomeActive")
        if !wasLaunchedFromAction {
            if videoTabSelected() {
                AppDelegate.vvc?.startStream()
            } else {
                AppDelegate.pvc?.takePicture()
            }
        }
        wasLaunchedFromAction = false
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()

        LibraryAPI.sharedInstance.sendStopStreamCommand(nil)
        
        IMFLogger.send() // send all IMFLogger logged data to the server
        IMFAnalytics.sharedInstance().sendPersistedLogs() // send all analytics data to the server
}
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.ibm.dws.NewFoo" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("doorbell", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    // ========================================
    //  didRegisterForRemoteNotificationsWithDeviceToken
    //    Registration was successful.
    //    Initialize connection to Bluemix using the app's credentials
    //    and register for IBM Push notifications.
    // ========================================
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        // Register for Bluemix push notifications
        LibraryAPI.sharedInstance.registerForPush(deviceToken)
        
    }
    
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        logger.logErrorWithMessages("Couldn't register: \(error)")
    }
    
    
    // ========================================
    //   didReceiveRemoteNotifiation
    //      Called by the framework whenever a remote notification (Push) is received
    //   Retrieve the message text (from the body) and the filename of the image (from the URL).
    //   If the app was Inactive or in the Background, the user has already tapped the notification
    //   so go directly to load the image.  If the app was in the foreground, display an alert
    //   so the user can choose to open the picture or not.
    // ========================================
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject])
    {
        
        logger.logInfoWithMessages("didReceiveRemoteNotification")
        logger.logInfoWithMessages(userInfo.description)
        
        if let aps = userInfo["aps"] as? NSDictionary {
            if let alert = aps["alert"] as? NSDictionary {
                if let message = alert["body"] as? NSString {
                    
                    if (application.applicationState == UIApplicationState.Inactive ||
                        application.applicationState == UIApplicationState.Background) {
                            
                        logger.logInfoWithMessages("App was in the background when push arrived")

                            
                    } else {
                        let noticeAlert = UIAlertController(
                            title: "Doorbell",
                            message: message as String,
                            preferredStyle: UIAlertControllerStyle.Alert)
                        
                        noticeAlert.addAction(UIAlertAction(
                            title: "Video",
                            style: .Default,
                            handler: { (action: UIAlertAction!) in
                                logger.logInfoWithMessages("User wants to see a video of who's at the door.")
                                if !self.videoTabSelected() {
                                    self.switchToVideo()
                                }

                        }))
                        noticeAlert.addAction(UIAlertAction(
                            title: "Picture",
                            style: .Default,
                            handler: { (action: UIAlertAction!) in
                                logger.logInfoWithMessages("User wants to see a picture of who's at the door.")
                                if self.videoTabSelected() {
                                    self.switchToPicture()
                                } else {
                                    AppDelegate.pvc?.takePicture()
                                }
                        }))
                        noticeAlert.addAction(UIAlertAction(
                            title: "Cancel",
                            style: .Default,
                            handler: { (action: UIAlertAction!) in
                                logger.logInfoWithMessages("User didn't care who was at the door")
                        }))
                        
                        if let sound = aps["sound"] as? String {
                            let fileURL: NSURL = NSBundle.mainBundle().URLForResource(sound, withExtension: nil)!
                            
                            do {
                                try self.avPlayer = AVAudioPlayer(contentsOfURL: fileURL)
                                self.avPlayer?.play()
                            } catch {
                                logger.logErrorWithMessages("Unable to create an audio player for the sound.")
                            }
                        }
                        
                        // Display the dialog
                        self.window?.rootViewController?.presentViewController(noticeAlert, animated: true, completion: nil)
                        
                    }
                }
            }
        }
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], withResponseInfo responseInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        
        print("handleActionWithIdentifier with identifier = " + identifier!)
        
        if identifier == "video" {
            if !self.videoTabSelected() {
                self.switchToVideo()
            }
        } else {
            if self.videoTabSelected() {
                self.switchToPicture()
            } else {
                AppDelegate.pvc?.takePicture()
            }            
        }
        
        wasLaunchedFromAction = true
        
        completionHandler();
    }
    
    func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {

        print("userActivity is \(userActivity)")

        let command = userActivity.activityType
        print("command is\(command)")
        
        switch userActivity.activityType {
        case Handoff.ActivityType.ViewPicture.rawValue:
            AppDelegate.pvc!.restoreUserActivityState(userActivity)
            break
        case Handoff.ActivityType.ViewVideo.rawValue:
            AppDelegate.vvc!.restoreUserActivityState(userActivity)
        default:
            break
            
        }
        return true
    }
    
    
    // ========================================
    //   registerVC
    //     static method used by the VideoViewController to register itself
    //     with the AppDelegate so the AppDelegate can later call the
    //     updatePicture method of the VideoViewController.
    // ========================================
    static func registerVVC(vc : VideoViewController) {
        self.vvc = vc
    }
    static func registerPVC(vc : PictureViewController) {
        self.pvc = vc
    }
    
    
    func videoTabSelected() -> Bool {
        if let tabBarController = self.window!.rootViewController as? UITabBarController {
            return tabBarController.selectedIndex == 1
        }
        return false;
    }
    
    func switchToVideo() {
        if let tabBarController = self.window!.rootViewController as? UITabBarController {
            return tabBarController.selectedIndex = 1
        }
        
    }
    func switchToPicture() {
        if let tabBarController = self.window!.rootViewController as? UITabBarController {
            return tabBarController.selectedIndex = 0
        }
        
    }

}

extension AppDelegate: WCSessionDelegate {
    
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {

        print("didReceiveMessage")
        
        let state = UIApplication.sharedApplication().applicationState
        if state == UIApplicationState.Background || state == UIApplicationState.Inactive {
            // iPhone app won't be able to talk to IoT Foundation if it is in the background
            // Send the Watch a dummy file with a status message
            let fm = NSFileManager()
            let url = try! fm.URLForDirectory(.CachesDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true).URLByAppendingPathComponent(WatchConstants.fileName)
            
            print("sending dummy message")
            // Send the image and date string to Watch
            
            let metadata = [
                WatchConstants.statusMetadataKey:"BACKGROUND"]
            
            let session = WCSession.defaultSession()
            session.transferFile(url, metadata: metadata)
            
        } else {
            
            // iOS app is in foreground
            if let _ = applicationContext[WatchConstants.takePictureCommand] {
                func statusUpdate (message: String) {
                }
                
                func pictureIsReady (picture: Picture) {
                    if let _ = picture.getWatchImageData() {
                        WatchUtils.transferPictureToWatch(picture)
                    } else {
                        print("no image in picture")
                    }
                }
                
                print("picture request")
                LibraryAPI.sharedInstance.takePicture(statusUpdate, completion: pictureIsReady)
                
            }
            
        }
        
        
    }
    
}


