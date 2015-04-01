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
        return NSURL(string: String(format: "ec2-52-11-217-88.us-west-2.compute.amazonaws.com/login?id=%@&password=%@", arguments: [id, password]))!
    }
    
    class func urlForCheck(id:String) -> NSURL {
        return NSURL(string: String(format: "ec2-52-11-217-88.us-west-2.compute.amazonaws.com/check_account?id=%@", arguments: [id]))!
    }
    
    class func urlForRegister(id:String, password:String) -> NSURL {
        return NSURL(string: String(format: "ec2-52-11-217-88.us-west-2.compute.amazonaws.com/register?id=%@&password=%@", arguments: [id, password]))!
    }
    
}