//
//  Account.swift
//  Chatchat
//
//  Created by Carl Cui on 2015-03-31.
//  Copyright (c) 2015 Scropioczn. All rights reserved.
//

import Foundation
import CoreData

class Account: NSManagedObject {

    @NSManaged var id: String
    @NSManaged var messages: NSSet
    @NSManaged var friends: NSSet

}
