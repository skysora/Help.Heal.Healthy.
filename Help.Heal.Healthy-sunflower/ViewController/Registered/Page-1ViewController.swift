//
//  Page-1ViewController.swift
//  Help.Heal.Healthy-sunflower
//
//  Created by YuMIng Haung on 2019/7/15.
//  Copyright © 2019 sunflower. All rights reserved.
//

import UIKit

class Page_1ViewController: UIViewController {

    @IBOutlet var SenceView: UIView!
    @IBOutlet weak var famaleFrontBtn: UIButton!
    @IBOutlet weak var maleFrontBtn: UIButton!
    var sex:Int = -1
    override func viewDidLoad() {
        super.viewDidLoad()
        //  给按钮添加事件
        famaleFrontBtn.addTarget(self, action:#selector(clickButton(_:)), for: .touchDown)
        maleFrontBtn.addTarget(self, action:#selector(clickButton(_:)), for: .touchDown)
        
    }
    @objc func clickButton(_ btn:UIButton){
        switch btn.tag {
        case 0:
            self.sex = 0
            famaleFrontBtn.setBackgroundImage(UIImage(named: "girl-hight"), for: .normal)
            maleFrontBtn.setBackgroundImage(UIImage(named: "boy"), for: .normal)
        case 1:
            self.sex = 1
            maleFrontBtn.setBackgroundImage(UIImage(named: "boy-hight"), for: .normal)
            famaleFrontBtn.setBackgroundImage(UIImage(named: "girl"), for: .normal)
        default:
            print("other")
        }
    }
    
    //判斷滑動
//    func addSwipeGesturesToSceneView() {
//        //向右滑
//        let swipeDownGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(RegisteredViewController.turnBackToLogin(withGestureRecognizer:)))
//        swipeDownGestureRecognizer.direction = .right
//        self.SenceView.addGestureRecognizer(swipeDownGestureRecognizer)
//    }
    
    @objc func turnBackToLogin(withGestureRecognizer recognizer: UIGestureRecognizer) {
        self.performSegue(withIdentifier: "goToLogin", sender: self)
    }
    
    
}
