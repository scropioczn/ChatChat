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
    
    class func urlForGetContacts(id:String) ->NSURL {
        return NSURL(string: String(format: "http://ec2-52-11-217-88.us-west-2.compute.amazonaws.com/get_contacts?id=%@", id))!
    }
    
    // id: user , cid: target (message is from cid to id)
    class func urlForGetMessages(id:String, cid:String) ->NSURL {
        return NSURL(string: String(format: "http://ec2-52-11-217-88.us-west-2.compute.amazonaws.com/get_messages?id=%@&cid=%@", id, cid).stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!
    }
    
    // id:user, cid:target (message is from id to cid)
    class func urlForSendMessage(id:String, cid:String, content:String, time:String) ->NSURL {
        let url =  NSURL(string: String(format: "http://ec2-52-11-217-88.us-west-2.compute.amazonaws.com/send_message?id=%@&cid=%@&content=%@&time=%@", id, cid, content, time).stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!
        
        return url
    }
    
}