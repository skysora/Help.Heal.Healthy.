//
//  Meal.swift
//  Help.Heal.Healthy-sunflower
//
//  Created by YuMIng Haung on 2019/7/22.
//  Copyright © 2019 sunflower. All rights reserved.
//

import Foundation
import UIKit
class Meal {
    let TABLEVIEWCELL_HIGHT = 75
    let name : String?
    let amount : String?
    let calories : String?
    let fruit: Int?
    let nut: Int?
    let milk: Int?
    let meat: Int?
    let rice: Int?
    let vegetable: Int?
    var image : UIImage?
    func setImage(image:UIImage){
        self.image = image
    }
    init(name:String) {
        self.name = name
        self.amount = "null"
        self.calories = "null"
        self.fruit = -1
        self.nut = -1
        self.milk = -1
        self.meat = -1
        self.rice = -1
        self.vegetable = -1
        self.image = nil
    }
    init(name:String,amount:String,
         calories:String,
         fruit: Int,
         nut: Int,
         milk: Int,
         meat: Int,
         rice: Int,
         vegetable: Int,
         image: UIImage) {
        self.name = name
        self.amount = amount
        self.calories = calories
        self.fruit = fruit
        self.nut = nut
        self.milk = milk
        self.meat = meat
        self.rice = rice
        self.vegetable = vegetable
        self.image = image
    }
}
