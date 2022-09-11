//
//  Post.swift
//  Help.Heal.Healthy
//
//  Created by iMac01 on 2019/6/24.
//  Copyright © 2019 sunflower. All rights reserved.
//

import Foundation
import UIKit
class PostMessage{
    var title: String?
    var date : String?
    var document : String?
    init(title:String,date:String,document:String) {
        self.title = title
        self.date = date
        self.document = document
    }
}
