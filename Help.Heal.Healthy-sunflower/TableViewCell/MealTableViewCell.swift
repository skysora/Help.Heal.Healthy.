//
//  MealTableViewCell.swift
//  Help.Heal.Healthy-sunflower
//
//  Created by YuMIng Haung on 2019/9/13.
//  Copyright © 2019 sunflower. All rights reserved.
//

import UIKit

class MealTableViewCell: UITableViewCell {

    @IBOutlet weak var mealImagle: UIImageView!
    @IBOutlet weak var mealName: UILabel!
    @IBOutlet weak var mealAmount: UILabel!
    @IBOutlet weak var mealCalorie: UILabel!
    
    @IBOutlet weak var mealDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
