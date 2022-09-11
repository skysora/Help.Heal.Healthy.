//
//  ingredientProgressView.swift
//  Help.Heal.Healthy-sunflower
//
//  Created by YuMing Haung on 2019/10/13.
//  Copyright © 2019 sunflower. All rights reserved.
//

import UIKit

class ingredientProgressView: UIProgressView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        transform = CGAffineTransform(scaleX: 1, y: 5)
    }


}
