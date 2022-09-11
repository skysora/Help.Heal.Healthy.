//
//  MealRecommendViewController.swift
//  Help.Heal.Healthy-sunflower
//
//  Created by YuMIng Haung on 2019/7/21.
//  Copyright © 2019 sunflower. All rights reserved.
//

import UIKit

class MealRecommendViewController: UIViewController {

    
    @IBOutlet weak var dialogText: UILabel!
    @IBOutlet weak var dialog: UIView!
    @IBOutlet weak var historyBtn: UIButton!
    @IBOutlet weak var areaBtn: UIButton!
    @IBOutlet weak var robbot: UIImageView!
    @IBOutlet weak var backGround: UIView!
    
    
    
    @IBOutlet weak var topBackBround: UIImageView!
    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityIndicatorView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        let server = Server()
//        
//        server.getMealRecommend(account: accountForEverySwift, completion:{
//            (result) in
//        })
        
        dialog.layer.cornerRadius = 20
        activityIndicatorView.isHidden = true
        self.ActivityIndicator.transform = CGAffineTransform(scaleX: 3, y: 3)
        let paraph = NSMutableParagraphStyle()
        //将行间距设置为28
        paraph.lineSpacing = 5
        let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 20),
                          NSAttributedString.Key.paragraphStyle: paraph]
        dialogText.attributedText = NSAttributedString(string: "現在為您推薦食物，請問要依照什麼做推薦？", attributes: attributes)
        // Do any additional setup after loading the view.
        // 生成建立通知的按鈕
        historyBtn.addTarget(self, action:
            #selector(MealRecommendViewController.onClickCreateNotificationBtn(_:)), for: UIControl.Event.touchUpInside)
    }
    
    @objc func onClickCreateNotificationBtn(_ sender: UIButton) {
        self.performSegue(withIdentifier: "historyGoToMealRemmendList", sender: self)
//        waitAnswer()
//        switch sender.tag {
//        case 0:
//            print("historyBtn")
//        case 1:
//            print("areaBtn")
//        default:
//            print("other")
//        }
    }
    func waitAnswer(){
        dialog.isHidden = true
        dialogText.isHidden = true
        historyBtn.isHidden = true
        areaBtn.isHidden = true
        playAnimation(block: robbot)
    }
    //滑動動畫
    func playAnimation(block:UIView)
    {
        print(self.topBackBround.center.y)
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 2, delay: 0, animations: {
            block.center.y = self.topBackBround.center.y + 130
        }){(finish) in
            self.activityIndicatorView.isHidden = false
            self.ActivityIndicator.startAnimating()
            UIView.animate(withDuration: 0.6, delay: 0.4, options: [.autoreverse],
                           animations: {
                            UIView.setAnimationRepeatCount(5)
                            block.center.y = self.topBackBround.center.y + 160
            }){ (finish) in
                self.performSegue(withIdentifier: "historyGoToMealRemmendList", sender: self)
                
            }
        }
    }
}
