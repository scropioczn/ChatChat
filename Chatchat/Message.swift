//
//  Message.swift
//  Chatchat
//
//  Created by Carl Cui on 2015-04-01.
//  Copyright (c) 2015 Scropioczn. All rights reserved.
//

import Foundation
import CoreData

class Message: NSManagedObject {

    @NSManaged var content: String
    @NSManaged var time: NSDate
    @NSManaged var from: NSNumber
    @NSManaged var belongTo: Account
    @NSManaged var invloves: Contact

}
