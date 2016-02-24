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
    func retrievePicture(pictureId : String, completion: (String?, Picture) -> Void) {
        let url = NSURL(string: "https://\(username):\(password)@\(username).cloudant.com/pictures/\(pictureId)")
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
    
            let picture = Picture(name: pictureId, date: NSDate())

            do {
                
                guard let dat = data else {
                    completion("No data returned from Cloudant", picture)
                    return
                }
                
                guard let json = try NSJSONSerialization.JSONObjectWithData(dat, options: []) as? NSDictionary else {
                    completion("Unable to convert Cloudant data to JSON", picture)
                    return
                }
                
                if let cloudantError = json["error"] as? String {
                    completion("Cloudant error: \(cloudantError)", picture)
                    return
                }
                        
                guard let payload = json["payload"] as? String else {
                    completion("No Cloudant Payload", picture)
                    return
                }
                
                guard payload != "" else {
                    completion("Payload was blank", picture)
                    return
                }
                
                picture.addPacket(payload, finalPacket: true)
                completion(nil,picture)
                
                
            } catch {
                print("Error converting response \(error)")
            }
            
            
        }
        
        task.resume()
        
    }

}