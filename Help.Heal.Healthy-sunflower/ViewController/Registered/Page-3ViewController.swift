//
//  Page-3ViewController.swift
//  Help.Heal.Healthy-sunflower
//
//  Created by YuMIng Haung on 2019/7/15.
//  Copyright © 2019 sunflower. All rights reserved.
//

import UIKit

class Page_3ViewController: UIViewController {

    @IBOutlet var SenceView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //判斷滑動
    func addSwipeGesturesToSceneView() {
        //向右滑
        let swipeDownGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(RegisteredViewController.turnBackToLogin(withGestureRecognizer:)))
        swipeDownGestureRecognizer.direction = .right
        self.SenceView.addGestureRecognizer(swipeDownGestureRecognizer)
    }
    @objc func turnBackToLogin(withGestureRecognizer recognizer: UIGestureRecognizer) {
        self.performSegue(withIdentifier: "goToLogin", sender: self)
    }

}
