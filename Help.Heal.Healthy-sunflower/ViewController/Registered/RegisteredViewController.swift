//
//  RegisteredViewController.swift
//  Help.Heal.Healthy
//
//  Created by YuMIng Haung on 2019/6/24.
//  Copyright © 2019 sunflower. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class RegisteredViewController: UIViewController,UITextFieldDelegate{

    @IBOutlet var senceView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        CSS()
        addSwipeGesturesToSceneView()
        // Do any additional setup after loading the view.
    }
    //判斷滑動
    func addSwipeGesturesToSceneView() {
        //向右滑
        let swipeDownGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(RegisteredViewController.turnBackToLogin(withGestureRecognizer:)))
        swipeDownGestureRecognizer.direction = .right
        self.senceView.addGestureRecognizer(swipeDownGestureRecognizer)
    }
    @objc func turnBackToLogin(withGestureRecognizer recognizer: UIGestureRecognizer) {
        self.performSegue(withIdentifier: "goToLogin", sender: self)
    }
    
    
//    @IBAction func registeredButton(_ sender: UIButton) {
//        let url = "http://140.134.26.159:5000/register"
//        //這裡要傳數據到後端去判斷帳號密碼對不對
//        let user = ["account": account.text, "password": password.text,"surePassword": surePassword.text]
//        Alamofire.request(url,method: .post,parameters:user as Parameters,encoding:JSONEncoding.default).responseJSON(completionHandler: {
//            response in
//            //成功且可以註冊
//            if(response.result.isSuccess){
//                let res: JSON = try! JSON(data: response.data!)
//                if((res["RegisterIsSuccess"]).boolValue){
//                    //跳轉畫面
//                    self.performSegue(withIdentifier: "RegisteredGoToHome", sender: self)
//                }else{
//                    if(self.password.text != self.surePassword.text){
//                        self.errorMessage.text = "密碼與確認密碼不一致"
//                    }else{
//                        self.errorMessage.text = "帳號已有人使用"
//                    }
//                }
//            }else{
//                print("error")
//            }
//        })
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
