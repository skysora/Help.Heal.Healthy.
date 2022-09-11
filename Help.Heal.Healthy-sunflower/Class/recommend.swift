//
//  recommend.swift
//  Help.Heal.Healthy-sunflower
//
//  Created by YuMing Haung on 2019/10/22.
//  Copyright © 2019 sunflower. All rights reserved.
//

import Foundation
import UIKit
class recommend {
    let name : String?
    let description : String?
    var image : UIImage?
    func setImage(image:UIImage){
        self.image = image
    }
    init(name: String,description: String,image: UIImage) {
        self.name = name
        self.description = description
        self.image = image
    }
}
