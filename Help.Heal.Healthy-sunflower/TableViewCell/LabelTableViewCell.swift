//
//  LabelTableViewCell.swift
//  Help.Heal.Healthy-sunflower
//
//  Created by YuMIng Haung on 2019/9/14.
//  Copyright © 2019 sunflower. All rights reserved.
//

import UIKit

class LabelTableViewCell: UITableViewCell {

    @IBOutlet weak var Label: UILabel!
    @IBOutlet weak var view: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
