//
//  FoodCheckListTableViewCell.swift
//  Help.Heal.Healthy-sunflower
//
//  Created by Alvin on 2019/10/14.
//  Copyright © 2019 sunflower. All rights reserved.
//

import UIKit

class FoodCheckListTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var foodPortion: UITextField!
    var foodEnglishName:String = ""
    var stepperClicked : (()->Void)? = nil
    let foodCheckListViewController = FoodCheckListViewController()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        foodPortion.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @objc func textFieldDidChange(_ textField:UITextField){
        
    }
    @IBAction func stepper(_ sender: UIStepper) {
        foodPortion.text = "\(sender.value)"
        stepperClicked?()
        //FoodCheckListViewController.foodSize[,default]
    }
}
