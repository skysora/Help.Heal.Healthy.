//
//  NavigationController.swift
//  Help.Heal.Healthy
//
//  Created by iMac01 on 2019/6/27.
//  Copyright © 2019 sunflower. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController,UINavigationControllerDelegate,UIGestureRecognizerDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.interactivePopGestureRecognizer?.delegate = self
        self.delegate = self
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
        //navigationBar.isTranslucent = true
        //view.backgroundColor = UIColor.clear
        //navigationBar.isHidden = true
        //navigationBar.backgroundColor = #colorLiteral(red: 0.9945440888, green: 0.7163427472, blue: 0.4059630632, alpha: 1)
        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
