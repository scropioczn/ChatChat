//
//  Message+Create.swift
//  Chatchat
//
//  Created by Carl Cui on 2015-03-31.
//  Copyright (c) 2015 Scropioczn. All rights reserved.
//

import Foundation
import CoreData



extension Message {
    
    /*
    // The function will return the messages in between [last, first+max] messages, ordered by timestamp (DESC)
    class func getMessage(id:String, cid:String, from first:Int, max:Int, inContext context:NSManagedObjectContext) -> [Message]? {
        var messages:[Message]?
        
        let request:NSFetchRequest = NSFetchRequest(entityName: "Message")
        
        request.predicate = NSPredicate(format: "belongTo.id LIKE %@", argumentArray: [id])
        request.sortDescriptors = [NSSortDescriptor(key: "timeStamp", ascending: false)]
        
        var err:NSError?
        
        var matches:[Message]? = context.executeFetchRequest(request, error: &err) as [Message]?
        
        if matches == nil {
            println(err)
        } else {
            messages = matches.
        }
        
        
        return messages
    }

    */
    
    // The function will return the messages ordered by timestamp (DESC)
    class func getMessage(id:String, cid:String, from first:Int, max:Int, inContext context:NSManagedObjectContext) -> [Message]! {
        var messages:[Message]!
        
        let request:NSFetchRequest = NSFetchRequest(entityName: "Message")
        
        request.predicate = NSPredicate(format: "(belongTo.id LIKE %@) AND (invloves.cid LIKE %@)", id, cid)
        request.sortDescriptors = [NSSortDescriptor(key: "time", ascending: false)]
        
        var err:NSError?
        
        var matches:[Message]? = context.executeFetchRequest(request, error: &err) as [Message]?
        
        if matches == nil {
            println(err)
        } else {
            messages = matches!
        }
        
        
        return messages
    }
    
    
    // create a new message
    // from = true: the message is from the user
    // from = false: the message is to the user
    class func createMessage(content:String, id:String, cid:String, at time:NSDate, from:Bool, inContext context:NSManagedObjectContext) -> Message! {
        var message:Message!
        
        message = NSEntityDescription.insertNewObjectForEntityForName("Message", inManagedObjectContext: context) as Message
        
        // accountc
        message.belongTo = Account.getAccount(id, inContext: context)!
        
        // target
        message.invloves = Contact.getContact(id, cid: cid, inContext: context)!
        
        message.content = content
        message.time = time
        
        message.from = NSNumber(bool: from)
        
        return message
    }
    
}