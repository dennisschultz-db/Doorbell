//
//  AppDelegate.swift
//  doorbell
//
//  Created by Dennis Schultz on 8/20/15.
//  Copyright (c) 2015 Dennis Schultz. All rights reserved.
//

import UIKit
import CoreData
import IBMMobileFirstPlatformFoundation
import AVKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var myToken: String?
    var pushService: IBMPush?
    static var vc: ViewController?
    var avPlayer: AVAudioPlayer?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // ========================================
        //  Register for push notifications
        // ========================================
        // Check to see if this is an iOS 8 device.
        let iOS8 = floor(NSFoundationVersionNumber) > floor(NSFoundationVersionNumber_iOS_7_1)
        if iOS8 {
            // Register for push in iOS 8
            let settings = UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound, categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(settings)
            UIApplication.sharedApplication().registerForRemoteNotifications()
        } else {
            // Register for push in iOS 7
            UIApplication.sharedApplication().registerForRemoteNotificationTypes(UIRemoteNotificationType.Badge | UIRemoteNotificationType.Sound | UIRemoteNotificationType.Alert)
        }
        
        // =======================================
        //   Connect to the MobileFirst Platform server
        // =======================================
        self.doConnect()
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.ibm.dws.doorbell" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as! NSURL
        }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("doorbell", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
        }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("doorbell.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
        }()
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
        }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
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
        self.myToken = deviceToken.description
        
        // Initialize the connection to Bluemix services
        IBMBluemix.initializeWithApplicationId(
            "<your-bluemix-applicationId>",
            andApplicationSecret: "<your-bluemix-application-secret>",
            andApplicationRoute: "<your-bluemix-application-route>")
        
        pushService = IBMPush.initializeService()
        if (pushService != nil)  {
            var push = pushService!
            push.registerDevice("testalias",
                withConsumerId: "testconsumerId",
                withDeviceToken: self.myToken).continueWithBlock{task in
            
                if(task.error() != nil) {
                    println("IBM Push Registration Failure...")
                    println(task.error().description)
                    
                } else {
                    println("IBM Push Registration Success...")
                }
                return nil
            }
        } else {
            println("Push service is nil")
        }
        
        
    }

    func getSubscriptions () -> Array<String>? {
        pushService!.getSubscriptions().continueWithBlock{task in
            if (task.error() != nil) {
                println("Failure during getSubscriptions operation")
                println(task.error().description)
                
            } else {
                if let subscriptions = task.result() as? Dictionary<String, AnyObject> {
                    // Wonky, I know, but an empty list of subscriptions ends up with
                    // subscriptions["subscriptions"] equal to Optional (()), which is not
                    // nil, but is also not a String
                    let subscription = subscriptions["subscriptions"] as? [String]
                    if (subscription?.count != 0) {
                        print("Device is subscribed to tags: ")
                        println(subscription!)
                    } else {
                        println("Device is not subscribed to any tags")
                    }
                    return subscription
                }
            }
            return nil
        }
        return nil
    }
    
    func getTags () -> Array<String>? {
        pushService!.getTags().continueWithBlock{task in
            println("Checking for available tags.")
            if (task.error() != nil) {
                println("Failure during getTags operation")
                println(task.error().description)
                
            } else {
                if let tags = task.result() as? Dictionary<String, AnyObject> {
                    let tag = tags["tags"] as? [String]
                    if (tag!.count != 0) {
                        println("The following tags are available")
                        println(tag!)
                        return tag!
                    } else {
                        println("No tags available for subscription")
                    }
                }
            }
            return nil
        }
        return nil
    }
    
    func application(application: UIApplication, subscribeToTag tag : String) {
        pushService!.subscribeToTag(tag).continueWithBlock{task in
            if (task.error() != nil) {
                println("Failure during tag subscription")
                println(task.error().description)
            } else {
                print("Successfully subscribed to tag: ")
                println(task.result().description)
            }
            return nil
        }
    
    }
    
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        println("Couldn't register: \(error)")
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
        println("didReceiveRemoteNotification")
        println(userInfo.description)
        
        if let aps = userInfo["aps"] as? NSDictionary {
            if let alert = aps["alert"] as? NSDictionary {
                if let fileName = userInfo["URL"] as? NSString {
                    if let message = alert["body"] as? NSString {
                        if let sound = aps["sound"] as? NSString {
                            if (application.applicationState == UIApplicationState.Inactive ||
                                application.applicationState == UIApplicationState.Background) {
                                    
                                    //                IBMPushAppMgr.get().appOpenedFromNotificationClickInBackground(userInfo)
                                    println("I was asleep!")
                                    self.getPicture(fileName)
                                    
                            } else {
                                var noticeAlert = UIAlertController(
                                    title: "Doorbell",
                                    message: message as String,
                                    preferredStyle: UIAlertControllerStyle.Alert)
                                
                                noticeAlert.addAction(UIAlertAction(
                                    title: "Ok",
                                    style: .Default,
                                    handler: { (action: UIAlertAction!) in
                                        println("User wants to see who's at the door")
                                        println(fileName)
                                        self.getPicture(fileName)
                                }))
                                noticeAlert.addAction(UIAlertAction(
                                    title: "Cancel",
                                    style: .Default,
                                    handler: { (action: UIAlertAction!) in
                                        println("Handle Cancel Logic here")
                                }))
                                
                                let fileURL:NSURL = NSBundle.mainBundle().URLForResource("Doorbell", withExtension: "mp3")!
                                
                                var error: NSError?
                                self.avPlayer = AVAudioPlayer(contentsOfURL: fileURL, error: &error)
                                if avPlayer == nil {
                                    if let e = error {
                                        println(e.localizedDescription)
                                    }
                                }
                                
                                self.avPlayer?.play()
                                
                                // Display the dialog
                                self.window?.rootViewController?.presentViewController(noticeAlert, animated: true, completion: nil)
                                
                            }
                            
                        }

                    }
                }
            }
        }
        
    }
    

    // ========================================
    //   getPicture
    //      Searches for and Retrieves picture from cloudant database
    // ========================================
    func getPicture(fileName : NSString) {
        
        println("Invoking REST Search...")
        
        // Search Cloudant for the document with the given fileName
        let searchRequest = WLResourceRequest(URL: NSURL(string: "/adapters/CloudantAdapter/search"), method: WLHttpMethodGet)
        let queryValue = "['pictures','ddoc','pictures',10,true,'fileName:\"" + (fileName as String) + "\"']"
        searchRequest.setQueryParameterValue(queryValue,forName: "params")
        searchRequest.sendWithCompletionHandler { (WLResponse response, NSError error) -> Void in
            if(error != nil){
                println("Invocation failure. ")
                println(error.description)
            }
            else if(response != nil){
                let jsonResponse = response.responseJSON
                if let rows = jsonResponse["rows"] as AnyObject? as? NSArray {
                    if (rows.count > 0) {
                        if let row = rows[0] as AnyObject? as? Dictionary<String,AnyObject> {
                            if let doc = row["doc"] as AnyObject? as? Dictionary<String,AnyObject> {
                                if let payload = doc["payload"] as AnyObject? as? Dictionary<String,AnyObject> {
                                    var base64String : String = payload["value"] as! String
                                    
                                    // Strip off prefix since UIImage doesn't seem to want it
                                    let prefixIndex = base64String.rangeOfString("base64,")?.endIndex
                                    base64String = base64String.substringWithRange(Range<String.Index>(start: prefixIndex!, end: base64String.endIndex))
                                    // Strip out any newline (\n) characters
                                    base64String = base64String.stringByReplacingOccurrencesOfString("\n", withString: "")
                                    
                                    // Convert to NSData
                                    let imageData = NSData(base64EncodedString: base64String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                                    
                                    // Create an image from the data
                                    let image = UIImage(data: imageData!)
                                    
                                    // Stuff it into the imageView of the ViewController
                                    AppDelegate.vc!.updatePicture(image!)
                                    
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // ========================================
    //   doConnect
    //      Connects to the IBM MobileFirst Plaform Foundation server
    // ========================================
    func doConnect() {
        
        println("Initializing...")
        let connectListener = MyConnectListener()
        WLClient.sharedInstance().wlConnectWithDelegate(connectListener)
    }
    
    // ========================================
    //   registerVC
    //     static method used by the ViewController to register itself
    //     with the AppDelegate so the AppDelegate can later call the
    //     updatePicture method of the ViewController.
    // ========================================
    static func registerVC(vc : ViewController) {
        self.vc = vc
    }
    
    
}

