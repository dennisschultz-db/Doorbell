//
//  Picture.swift
//  doorbell
//
//  Created by Dennis Schultz on 12/28/15.
//  Copyright © 2015 Dennis Schultz. All rights reserved.
//

import Foundation
import UIKit


class Picture: NSObject {
    
    let name                        : String!       // Pi filename.  Originates as the timestamp when the picture is taken.
    let date                        : NSDate!       // Date when the picture was taken
    private var image               : UIImage?      // Actual image of picture
    private var imageStringData     : String = ""   // Base 64 encoded string of image
    private var imageDecodedData    : NSData?       // Decoded data object of image
    private var watchImageData      : NSData?       // Lower resolution version for Apple Watch
    private var imageComplete       : Bool = false
    
    init(name: String, date: NSDate) {
        self.name = name
        self.date = date
    }
    
    // ===========================================================================
    /// Adds one packet to the end of the imageStringData.
    /// Used to assemble the string data when being recieved in packets
    /// over MQTT.  If finalPacket is true, the decoded data, watch image data
    /// and image will be created by this method.
    ///
    ///  - parameters:
    ///    - packet : A "chunk" of Base64 encoded string that will be added to the
    ///      picture's image string data.
    ///    - finalPacket : boolean.  True if this is the last packet received.
    func addPacket( packet : String, finalPacket : Bool = false) {
        self.imageStringData = self.imageStringData + packet
        if finalPacket {
            imageComplete = true
            imageDecodedData = NSData(
                base64EncodedString: imageStringData,
                options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
            image = UIImage(data: imageDecodedData!)
            
            let smallerImage = resizedImage(image!, newWidth: 350)
            watchImageData = NSData(data: UIImagePNGRepresentation(smallerImage)!)
        } else {
            imageComplete = false
        }
    }
    
    // MARK: Getters
    func getImage() -> UIImage? {
        if imageComplete {
            return image!
        } else {
            return nil
        }
    }
    
    func getImageStringData () -> String {
        if imageComplete {
            return imageStringData
        } else {
            return ""
        }
    }
    
    func getWatchImageData () -> NSData? {
        if imageComplete {
            return watchImageData
        } else {
            return nil
        }
    }
    
    func getImageDecodedData () -> NSData? {
        if imageComplete {
            return imageDecodedData
        } else {
            return nil
        }
    }
    
    // MARK: helper functions
    
    // ===========================================================================
    /// Returns a resized version of the image.  Used to scale down the image
    /// for transfer to the Apple Watch.
    ///
    ///  - parameters:
    ///    - image : UIImage to be resized
    ///    - newWidth : Desired width of the image.  Height will be scaled
    ///    accordingly.
    ///  - returns:  UIImage scaled to the desired width
    private func resizedImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }

}
