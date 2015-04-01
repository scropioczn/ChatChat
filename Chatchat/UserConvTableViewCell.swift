//
//  UserConvTableViewCell.swift
//  Chatchat
//
//  Created by Carl Cui on 2015-03-31.
//  Copyright (c) 2015 Scropioczn. All rights reserved.
//

import UIKit

class UserConvTableViewCell: UITableViewCell {

    @IBOutlet weak var conversation: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
