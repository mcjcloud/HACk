//
//  HkClassTableViewCell.swift
//  HACk
//
//  Created by Brayden Cloud on 12/2/16.
//  Copyright © 2016 Brayden Cloud. All rights reserved.
//

import UIKit

class HkClassTableViewCell: UITableViewCell {
    
    @IBOutlet var classNameLabel: UILabel!
    @IBOutlet var formativeLabel: UILabel!
    @IBOutlet var summativeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    /*
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    */
}
