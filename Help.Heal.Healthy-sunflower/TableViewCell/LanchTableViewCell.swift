//
//  LanchTableViewCell.swift
//  Help.Heal.Healthy-sunflower
//
//  Created by YuMIng Haung on 2019/7/22.
//  Copyright © 2019 sunflower. All rights reserved.
//

import UIKit

class LaunchTableViewCell: UITableViewCell {
    @IBOutlet weak var lanchImage: UIImageView!
    
    @IBOutlet weak var launchMealName: UILabel!
    
    @IBOutlet weak var launchQuantity: UILabel!
    
    @IBOutlet weak var launchCalories: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
