//
//  PictureViewController.swift
//  doorbell
//
//  Created by Dennis Schultz on 12/26/15.
//  Copyright © 2015 Dennis Schultz. All rights reserved.
//

import Foundation
import UIKit

class PictureViewController: UIViewController {
    
    // UI controls
    @IBOutlet weak var busyIndicator: UIActivityIndicatorView!
    @IBOutlet weak var TakePictureBarButton: UIBarButtonItem!
    @IBOutlet weak var pictureImage: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    
    let logger = IMFLogger(forName: "PictureViewController")
    
    
    override func viewWillAppear(animated: Bool) {
        // Override method invoked each time this view is added to the
        // hierarchy.  
        
        logger.logInfoWithMessages("viewWillAppear")
        
        // Blank out the picture image.
        pictureImage.image = UIImage(imageLiteral: "doorbell-300x300.png")
        
        // Stop the video stream on the Pi.  The video stream must be stopped
        // to release the camera to take a still picture.
        stopStream()
    }

    override func viewDidLoad() {
        logger.logInfoWithMessages("viewDidLoad")

        super.viewDidLoad()
        
        // Register this view controller with the AppDelegate so it will be able to update the UI
        // when push notifications come in.
        AppDelegate.registerPVC(self)
        
        // Put a border around the image
        pictureImage.layer.cornerRadius = 10.0
        pictureImage.clipsToBounds = true
        pictureImage.layer.borderColor = UIColor.whiteColor().CGColor
        pictureImage.layer.borderWidth = 3.0
        
        // Configure the busy indicator
        busyIndicator.activityIndicatorViewStyle = .WhiteLarge
        busyIndicator.hidesWhenStopped = true

    }
    
    @IBAction func takePicture(sender: UIBarButtonItem) {
        getPicture()
    }
    
    // MARK: Private methods
    
    // ===========================================================================
    ///  Updates the status on the display, then stops the video stream on the Pi.
    ///
    ///  - parameters:
    ///     - message: A string to be written.
    private func stopStream() {
        updateStatus("Stopping video stream...")
        LibraryAPI.sharedInstance.sendStopStreamCommand(streamStoppedCallback)
    }
    
    // ===========================================================================
    ///  Helper method that writes the given messge to the status label.
    ///
    ///  - parameters:
    ///     - message: A string to be written.
    private func updateStatus(message: String) {
        statusLabel.text = message
    }

    
    // MARK: Public control methods:
    
    // ===========================================================================
    ///  Gets a picture, either from the Cloudant database or directly from the Raspberry Pi.
    ///
    ///  - parameters:
    ///     - pictureId: The ID of the picture to be retrieved.  
    ///       - If nil, the IoT Foundation
    ///       will be used to ask the Pi to take a picture, then return it via MQTT events.
    ///       - If not nil, pictureId contains a string representation of the _id of a
    ///       Cloudant document for the picture.  Cloudant will be used to retrieve the picture.
    func getPicture(pictureId: String? = nil) {
        if (pictureId != nil) {
            logger.logInfoWithMessages("Get doorbell picture")
            updateStatus("Retrieving doorbell picture")
            
            // Blank out the picture image.  This is done so it is obvious a new
            // picture has been loaded if a user takes successive pictures.
            pictureImage.image = UIImage(imageLiteral: "doorbell-300x300.png")
            
            busyIndicator.startAnimating()
            LibraryAPI.sharedInstance.retrievePicture(pictureId!, completion: pictureTakenCallback)
            
        } else {
            logger.logInfoWithMessages("Take picture")
            updateStatus("Taking picture...")
            
            // Blank out the picture image.  This is done so it is obvious a new
            // picture has been loaded if a user takes successive pictures.
            pictureImage.image = UIImage(imageLiteral: "doorbell-300x300.png")
            
            busyIndicator.startAnimating()
            LibraryAPI.sharedInstance.takePicture(updateStatus, completion: pictureTakenCallback)
        }
    }

    // MARK: Completion Handlers:

    // ===========================================================================
    ///  Called when the streamStopped event is recieved from the Raspberry Pi.
    ///
    ///  - parameters:
    ///     - ipAddress: A string representing the IP address of the Raspberry Pi.
    ///  This will always be a dummy or blank address when the stream is stopped.
    private func streamStoppedCallback (ipAddress: String) {
        getPicture()
    }
    
    // ===========================================================================
    ///  Called when the pictureTaken event is recieved from the Raspberry Pi.
    ///
    ///  - parameters:
    ///     - picture: The picture that was returned from the Raspberry Pi.
    private func pictureTakenCallback (error : String?, picture : Picture) {
        
        // Update UI on the main queue
        dispatch_async(dispatch_get_main_queue(), {
            self.busyIndicator.stopAnimating()
            
            guard error == nil else {
                self.updateStatus(error!)
                return
            }
            
            // Format a human readable date string
            let formatter = NSDateFormatter()
            formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            formatter.timeStyle = .ShortStyle
            let pictureDate = formatter.stringFromDate(picture.date)
            
            // Update status message and image
            self.updateStatus(" \(pictureDate)")
            self.pictureImage.image = picture.getImage()
            
            // Send the image and date string to Watch
            WatchUtils.transferPictureToWatch(picture)
        })
    }
    

    override func restoreUserActivityState(activity: NSUserActivity) {
        stopStream()
    }
}
