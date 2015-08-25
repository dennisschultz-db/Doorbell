//
//  ViewController.swift
//  doorbell
//
//  Created by Dennis Schultz on 8/20/15.
//  Copyright (c) 2015 Dennis Schultz. All rights reserved.
//

import UIKit
import IBMMobileFirstPlatformFoundation

class ViewController: UIViewController {

    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register this view controller with the AppDelegate so it will be able to update the image later
        AppDelegate.registerVC(self)

        // Put a border around the image
        imageView.layer.cornerRadius = 10.0
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.whiteColor().CGColor
        imageView.layer.borderWidth = 2.0
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // ====================================
    //   clearPicture
    //     Resets the doorbell image to the default
    // ====================================
    @IBAction func clearPicture(sender: UIButton) {
        self.imageView.image = UIImage(named: "doorbell-300x300.png")
    }
    
    // ====================================
    //   updatePicture
    //     Sets the doorbell image to the given image
    // ====================================
    func updatePicture (image : UIImage?) {
        self.imageView.image = image 
    }
    
}

