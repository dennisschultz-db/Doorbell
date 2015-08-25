//
//  MyConnectListener.swift
//  doorbell
//
//  Created by Dennis Schultz on 8/20/15.
//  Copyright (c) 2015 Dennis Schultz. All rights reserved.
//

import Foundation
import IBMMobileFirstPlatformFoundation


class MyConnectListener: NSObject, WLDelegate {
    
    var strResponse = ""
    
    
    func onSuccess(response: WLResponse!) {
        var resultText = "Connection success. "
        if(response != nil){
            resultText += response.responseText
        }
        println(resultText)
    }
    
    func onFailure(response: WLFailResponse!) {
        var resultText = "Connection failure. "
        if(response != nil){
            resultText += response.errorMsg
        }
        println(resultText)
    }
}
