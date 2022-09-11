//
//  FoodInsertTableViewCell.swift
//  Help.Heal.Healthy
//
//  Created by Ａlvin on 2019/7/19.
//  Copyright © 2019 sunflower. All rights reserved.
//

import UIKit
import Cosmos

class FoodInsertTableViewCell: UITableViewCell {

    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var foodWeightlabel: UILabel!
    @IBOutlet weak var foodCaloireLabel: UILabel!
    @IBOutlet weak var comformButton: UIButton!
    
    var actionBlock: (() -> Void)? = nil
    var select = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        comformButton.addTarget(self, action: #selector(comformButtonClicked(_:)), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @objc func comformButtonClicked(_ sender: UIButton) {
        actionBlock?()
       
        
    }
}
