//
//  Contact.swift
//  Chatchat
//
//  Created by Carl Cui on 2015-04-01.
//  Copyright (c) 2015 Scropioczn. All rights reserved.
//

import Foundation
import CoreData

class Contact: NSManagedObject {

    @NSManaged var cid: String
    @NSManaged var isFriend: Account
    @NSManaged var joined: NSSet

}
