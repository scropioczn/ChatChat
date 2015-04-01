//
//  Message.swift
//  Chatchat
//
//  Created by Carl Cui on 2015-03-31.
//  Copyright (c) 2015 Scropioczn. All rights reserved.
//

import Foundation
import CoreData

class Message: NSManagedObject {

    @NSManaged var content: String
    @NSManaged var time: NSDate
    @NSManaged var belongTo: Account
    @NSManaged var invloves: Contact

}
