//
//  ChatchatFetcher.swift
//  Chatchat
//
//  Created by Carl Cui on 2015-04-01.
//  Copyright (c) 2015 Scropioczn. All rights reserved.
//

import Foundation

class ChatchatFetcher {
    class func urlForSignIn(id:String, password:String) -> NSURL {
        return NSURL(string: String(format: "http://ec2-52-11-217-88.us-west-2.compute.amazonaws.com/login?id=%@&password=%@", id, password))!
    }
    
    class func urlForCheck(id:String) -> NSURL {
        let url = NSURL(string: String(format: "http://ec2-52-11-217-88.us-west-2.compute.amazonaws.com/check_account?id=%@", id))!
        
        return url
    }
    
    class func urlForRegister(id:String, password:String) -> NSURL {
        let url =  NSURL(string: String(format: "http://ec2-52-11-217-88.us-west-2.compute.amazonaws.com/account?id=%@&password=%@", id, password))!
        
        return url
    }
    
}