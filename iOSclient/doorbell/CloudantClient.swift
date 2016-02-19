//
//  CloudantClient.swift
//  doorbell
//
//  Created by Dennis Schultz on 2/18/16.
//  Copyright © 2016 Dennis Schultz. All rights reserved.
//

import Foundation

class CloudantClient: NSObject {
    let logger = IMFLogger(forName: "CloudantClient")
    let username = configuration?["Cloudant"]!["username"] as! String
    let password = configuration?["Cloudant"]!["password"] as! String
    
    override init() {
        
        
    }
    
    
    // ===========================================================================
    ///  Retrieves the picture data from the Cloudant database
    ///
    ///  - parameters:
    ///    - pictureId : _id of the document.
    ///    - completion: Completion handler that will be invoked when the command completes.
    func retrievePicture(pictureId : String, completion: (Picture) -> Void) {
        let url = NSURL(string: "https://\(username):\(password)@\(username).cloudant.com/pictures/\(pictureId)")
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
    
            do {
                if let dat = data {
                    let json = try NSJSONSerialization.JSONObjectWithData(dat, options: []) as? NSDictionary
                    
                    let payload = json!["payload"] as? String
                    if payload != "" {
                        let picture = Picture(name: pictureId, date: NSDate())
                        picture.addPacket(payload!, finalPacket: true)

                        completion(picture)
                       
                    } else {
                        self.logger.logErrorWithMessages("Payload was empty")
                    }
                    
                }
            } catch {
                print("Error converting response \(error)")
            }
            
            
        }
        
        task.resume()
        
    }

}