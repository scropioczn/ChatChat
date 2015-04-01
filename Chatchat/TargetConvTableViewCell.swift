//
//  TargetConvTableViewCell.swift
//  Chatchat
//
//  Created by Carl Cui on 2015-04-01.
//  Copyright (c) 2015 Scropioczn. All rights reserved.
//

import UIKit

class TargetConvTableViewCell: UITableViewCell {

    @IBOutlet weak var targetID: UILabel!
    @IBOutlet weak var targetConv: UILabel!
    @IBOutlet weak var targetTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
