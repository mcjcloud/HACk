//
//  HkAssignmentTableViewCell.swift
//  HACk
//
//  Created by Brayden Cloud on 12/5/16.
//  Copyright © 2016 Brayden Cloud. All rights reserved.
//

import UIKit

class HkAssignmentTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var assignedLabel: UILabel!
    @IBOutlet var dueLabel: UILabel!
    @IBOutlet var gradeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
