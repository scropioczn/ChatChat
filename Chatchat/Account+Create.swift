//
//  Account+Create.swift
//  Chatchat
//
//  Created by Carl Cui on 2015-04-01.
//  Copyright (c) 2015 Scropioczn. All rights reserved.
//

import Foundation
import CoreData

extension Account {
    
    // get account with id
    class func getAccount(id:String, inContext context:NSManagedObjectContext) -> Account? {
        var account:Account? = nil
        
        let request = NSFetchRequest(entityName: "Account")
        request.predicate = NSPredicate(format: "id LIKE %@", argumentArray: [id])
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true, selector: Selector("localizedStandardCompare"))]
        
        var err:NSError?
        
        let matches = context.executeFetchRequest(request, error: &err) as [Account]?
        
        if let match = matches {
            if match.count == 1 {
                account = match[0]
            }
        } else {
            println(err)
        }
        
        
        return account
    }
    
    // create a new account
    class func createAccount(id:String, inContext context:NSManagedObjectContext) -> Account? {
        var account:Account? = nil
        
        let request = NSFetchRequest(entityName: "Account")
        request.predicate = NSPredicate(format: "id LIKE %@", argumentArray: [id])
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true, selector: Selector("localizedStandardCompare"))]
        
        var err:NSError?
        
        let matches = context.executeFetchRequest(request, error: &err) as [Account]?
        
        if let match = matches {
            if match.count == 0 {
                account = NSEntityDescription.insertNewObjectForEntityForName("Account", inManagedObjectContext: context) as? Account
                
                if account != nil {
                    // account attributes setup
                    account!.id = id
                }
            }
        } else {
            println(err)
        }
        
        return account
    }
    
    
    
}