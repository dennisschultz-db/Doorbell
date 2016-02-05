//
//  VideoViewController.swift
//  doorbell
//
//  Created by Dennis Schultz on 8/20/15.
//  Copyright (c) 2015 Dennis Schultz. All rights reserved.
//

import UIKit

let dummyIPAddress = "---.---.---.---"

class VideoViewController: UIViewController {

    // UI controls
    @IBOutlet weak var ConnectBarButton: UIBarButtonItem!
    @IBOutlet weak var ipAddressLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var movieView: UIView!
    @IBOutlet weak var busyIndicator: UIActivityIndicatorView!
    
    // Video player control
    private let mediaPlayer = VLCMediaPlayer()
    private var streamIsActive = false
    private var finishedTrying = false
    private var testSuccessful = false
    
    let logger = IMFLogger(forName: "VideoViewController")
    
    override func viewWillAppear(animated: Bool) {
        // Override method invoked each time this view is added to the
        // hierarchy.
        
        logger.logInfoWithMessages("viewWillAppear")
        
        // Start the video streamer on the Pi
        startStream()
    }
    
    override func viewDidLoad() {
        logger.logInfoWithMessages("viewDidLoad")

        super.viewDidLoad()

        // Register this view controller with the AppDelegate so it will be able to update the UI 
        // when push notifications come in.
        AppDelegate.registerVVC(self)
        
        // Put a border around the video view
        movieView.layer.cornerRadius = 10.0
        movieView.clipsToBounds = true
        movieView.layer.borderColor = UIColor.whiteColor().CGColor
        movieView.layer.borderWidth = 3.0
        
        // Configure the busy indicator
        busyIndicator.activityIndicatorViewStyle = .WhiteLarge
        busyIndicator.hidesWhenStopped = true
        
        setNormalStatus(dummyIPAddress)
        
        /* setup the media player instance, give it a delegate and something to draw into */
        mediaPlayer.setDelegate(self)
        mediaPlayer.drawable = movieView
                
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Actions:
    
    // ====================================
    //   connectToStream
    //     Connects the VLC mediaPlayer object
    //     to the streaming video source from
    //     the Raspberry Pi.
    //
    // ====================================
    @IBAction func connectToStream(sender: UIBarButtonItem) {
        connectToStream()
    }
    
    

    // MARK: UI Management Helpers:
    private func setNormalStatus(value: String) {
        ipAddressLabel.text = value
        ipAddressLabel.textColor = UIColor.blackColor()
        ipAddressLabel.font = UIFont.systemFontOfSize(ipAddressLabel.font.pointSize)
    }
    
    private func setAlarmStatus(value: String) {
        ipAddressLabel.text = value
        ipAddressLabel.textColor = UIColor.redColor()
        ipAddressLabel.font = UIFont.italicSystemFontOfSize(ipAddressLabel.font.pointSize)
    }
    
    

    // MARK: Public control methods for use by AppDelegate
    
    func startStream() {
        statusLabel.text = "Starting video stream..."
        mediaPlayer.stop()
        setNormalStatus(dummyIPAddress)
        busyIndicator.startAnimating()
        LibraryAPI.sharedInstance.sendStartStreamCommand(streamStartedCallback)
    }

    func connectToStream() {
        let url = NSURL(string: "http://" + ipAddressLabel.text! + ":8554/")
        let media = VLCMedia(URL: url)
        mediaPlayer.setMedia(media)
        mediaPlayer.play()
    }
    
    
    // MARK: Completion Handlers:
    
    // ====================================
    //   streamStartedCallback
    //      Called when the streamStarted or streamStopped
    //      events are recieved from the Raspberry Pi.
    //
    //      If the stream was just stopped, ipAddress will
    //      contain the dummyIPAddress string.
    //
    //      If the stream was just started, ipAddress will
    //      contain the IP address of the Pi, which needs to 
    //      be validated, then posted to the UI.
    // ====================================
    private func streamStartedCallback (ipAddress: String) {

        setNormalStatus(ipAddress)

        if ipAddress != dummyIPAddress {
            statusLabel.text = "Buffering stream..."

            // Give the stream time to start up before connecting
            NSRunLoop.currentRunLoop().runUntilDate(NSDate(timeIntervalSinceNow: 1.5))
            
            self.busyIndicator.stopAnimating()
            
            statusLabel.text = "Connecting to stream..."
            connectToStream()

            // This is here for no reason other than so that the statusLabel has
            // time to be visible.
            NSRunLoop.currentRunLoop().runUntilDate(NSDate(timeIntervalSinceNow: 1.5))
            statusLabel.text = ""
            
        }
        
    }
    
    override func restoreUserActivityState(activity: NSUserActivity) {
        connectToStream()
    }
    
}