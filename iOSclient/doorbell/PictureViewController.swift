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
    
    var picture: Picture!
    var pictureData: String = ""
    var decodedData: NSData!
    
    
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
        
        takePicture()
    }
    
    
    // MARK: Public control methods:
    
    func stopStream() {
        updateStatus("Stopping video stream...")
        LibraryAPI.sharedInstance.sendStopStreamCommand(streamStoppedCallback)
    }
    
    func takePicture() {
        logger.logInfoWithMessages("Take picture")
        updateStatus("Taking picture...")
        
        // Blank out the picture image.  This is done so it is obvious a new
        // picture has been loaded if a user takes successive pictures.
        pictureImage.image = UIImage(imageLiteral: "doorbell-300x300.png")
        
        busyIndicator.startAnimating()
        LibraryAPI.sharedInstance.takePicture(updateStatus, completion: pictureTakenCallback)
    }

    // MARK: Completion Handlers:
    
    // ====================================
    //   stopStartedCallback
    //      Called when the streamStopped
    //      events are recieved from the Raspberry Pi.
    //
    // ====================================
    private func streamStoppedCallback (ipAddress: String) {
        takePicture()
    }
    
    // ====================================
    //   pictureTakenCallback
    //      Called when a picture is 
    //      recieved from the Raspberry Pi.
    //
    // ====================================
    private func pictureTakenCallback (picture : Picture) {
        self.busyIndicator.stopAnimating()
        
        // Format a human readable date string
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        formatter.timeStyle = .ShortStyle
        let pictureDate = formatter.stringFromDate(picture.date)
        
        // Update status message and image
        updateStatus(" \(pictureDate)")
        pictureImage.image = picture.getImage()
        
        // Send the image and date string to Watch
        WatchUtils.transferPictureToWatch(picture)
    }
    
    // ====================================
    //   pictureTakenCallback
    //      Called by the API to update status
    //      during a long-running command.
    //
    // ====================================
    private func updateStatus(message: String) {
        statusLabel.text = message
    }

    override func restoreUserActivityState(activity: NSUserActivity) {
        stopStream()
    }
}
