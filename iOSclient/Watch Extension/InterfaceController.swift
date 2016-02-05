//
//  InterfaceController.swift
//  Watch Extension
//
//  Created by Dennis Schultz on 1/15/16.
//  Copyright © 2016 Dennis Schultz. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    
    @IBOutlet var pictureImage : WKInterfaceGroup!
    @IBOutlet var button       : WKInterfaceButton!

    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Default activity for handoff is ViewPicture
        updateUserActivity(
            Handoff.ActivityType.ViewPicture.rawValue,
            userInfo: [Handoff().activityValueKey:"init"],
            webpageURL: nil)

        if context != nil {
            // Interface launched with an image in the context
            if let watchImage = context as? WatchImage {
                pictureImage.setBackgroundImage(watchImage.image)
                button.setTitle(watchImage.date)
            }

        } else {
            pictureImage.setBackgroundImageNamed("doorbell-180x180")

        }
    }
    
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func refreshMenuButtonTapped () {
        pictureImage.setBackgroundImageNamed("doorbell-180x180")
        CommunicationManager.sendPictureRequest()
    }
    
    @IBAction func buttonTapped () {
        pictureImage.setBackgroundImageNamed("doorbell-180x180")
        CommunicationManager.sendPictureRequest()
    }
    
}

