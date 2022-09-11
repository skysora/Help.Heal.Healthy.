//
//  PostTableViewCell.swift
//  Help.Heal.Healthy
//
//  Created by iMac01 on 2019/6/24.
//  Copyright © 2019 sunflower. All rights reserved.
//

import UIKit

class WarnTableViewCell: UITableViewCell {

    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var typeLabel: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var typeLabel2: UIButton!
    @IBOutlet weak var wordLabel2: UILabel!
    @IBOutlet weak var dateLabel2: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}
