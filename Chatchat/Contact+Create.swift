//
//  Contact+Create.swift
//  Chatchat
//
//  Created by Carl Cui on 2015-04-01.
//  Copyright (c) 2015 Scropioczn. All rights reserved.
//

import Foundation
import CoreData


extension Contact {
    
    // get the contact by specifying id and cid
    class func getContact(id:String, cid:String, inContext context:NSManagedObjectContext) -> Contact? {
        var contact:Contact? = nil
        
        let request = NSFetchRequest(entityName: "Contact")
        request.predicate = NSPredicate(format: "(cid LIKE %@) AND (isFriend.id LIKE %@)", argumentArray: [cid, id])
        request.sortDescriptors = [NSSortDescriptor(key: "cid", ascending: true, selector: Selector("localizedStandardCompare"))]
        
        var err:NSError?
        
        let matches = context.executeFetchRequest(request, error: &err) as [Contact]?
        
        if matches != nil {
            if matches!.count > 0 {
                contact = matches![0]
            }
        } else {
            println(err)
        }
        
        return contact
    }
    
    // get contacts of a user
    class func getContactsOf(id:String, inContext context:NSManagedObjectContext) -> [Contact]? {
        var contacts:[Contact]? = nil
        
        let request = NSFetchRequest(entityName: "Contact")
        request.predicate = NSPredicate(format: "isFriend.id LIKE %@", argumentArray: [id])
        request.sortDescriptors = [NSSortDescriptor(key: "cid", ascending: true, selector: Selector("localizedStandardCompare"))]
        
        var err:NSError?
        
        let matches = context.executeFetchRequest(request, error: &err) as [Contact]?
        
        if matches != nil {
            contacts = matches
        } else {
            println(err)
        }
        
        return contacts
    }
    
    // create new contact 
    class func createContact(id:String, cid:String, inContext context:NSManagedObjectContext) -> Contact? {
        var contact:Contact? = nil
        
        let request = NSFetchRequest(entityName: "Contact")
        request.predicate = NSPredicate(format: "(cid LIKE %@) AND (isFriend.id LIKE %@)", argumentArray: [cid, id])
        request.sortDescriptors = [NSSortDescriptor(key: "cid", ascending: true, selector: Selector("localizedStandardCompare"))]
        
        var err:NSError?
        
        let matches = context.executeFetchRequest(request, error: &err) as [Contact]?
        
        if matches != nil {
            if matches!.count > 0 {
                
            } else {
                contact = NSEntityDescription.insertNewObjectForEntityForName("Contact", inManagedObjectContext: context) as? Contact
                
                if contact != nil {
                    contact!.cid = cid
                    // since in this stage, the user should be signed in, account should be one match
                    contact!.isFriend = Account.getAccount(id, inContext: context)!
                }
            }
        } else {
            println(err)
        }
        
        return contact
    }
    
}