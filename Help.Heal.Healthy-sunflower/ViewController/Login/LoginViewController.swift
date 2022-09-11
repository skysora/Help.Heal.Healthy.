//
//  LoginViewController.swift
//  Help.Heal.Healthy
//
//  Created by YuMIng Haung on 2019/6/18.
//  Copyright © 2019 sunflower. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import UserNotifications
import FacebookLogin
import FacebookCore

var accountForEverySwift = ""
class LoginViewController: UIViewController,UITextFieldDelegate{
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var account: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    var user: Parameters!
    var isLogin : Bool = false
    let server = Server()
    let notification = selfNotifications()
    var confimUserIsCorrectError: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // 生成建立通知的按鈕
        loginBtn.addTarget(self, action:
            #selector(LoginViewController.onClickCreateNotificationBtn(_:)), for: UIControl.Event.touchUpInside)
        CSS()
        if let token = AccessToken.current{
            self.performSegue(withIdentifier: "loginGoToHome", sender: self)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(isLogin){
            self.performSegue(withIdentifier: "loginGoToHome", sender: self)
        }
    }
    
    
    func CSS(){
        errorMessage.text = " "
        loginBtn.layer.cornerRadius = 20
    }
    //傳值到別的頁面
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(isLogin){
            let tabBarcontroller = segue.destination as! MainViewController
            let controller = tabBarcontroller.viewControllers?.first as?
            HomeViewController
            //把segue.destination強制轉型成detailViewController
            controller?.account = account.text
        }
    }
    //鍵盤按return影隱藏
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //鍵盤按其他位置隱藏
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    //帳號登入
    @IBAction func confimUserIsCorrect(_ sender: UIButton) {

        server.login(account: account.text!,password: password.text!) {
            (result) in
//            判斷是否登入成功
              if(result){
                self.isLogin = true
                accountForEverySwift = self.account.text!
                self.performSegue(withIdentifier: "loginGoToHome", sender: self)
                }else{
                    self.alertNoData()
                    self.errorMessage.text = "帳號或密碼錯誤"
                    self.errorMessage.textColor = .red
                }
        }
//        self.performSegue(withIdentifier: "loginGoToHome", sender: self)
    }
    func alertNoData(){
        let controller = UIAlertController(title: "登入提醒", message: "即將進入註冊程序，請確認是否為打錯帳號密碼", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "註冊", style: .default) { (_) in
            self.performSegue(withIdentifier: "goToRegistered", sender: self)
        }
        controller.addAction(okAction)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
        
    }
    //點擊建立通知按鈕
    @objc func onClickCreateNotificationBtn(_ sender: UIButton) {
        server.setNotifiaction(account: account.text!){
            (responds) in
        }

        
    }
    //the buuton can login with facebook
    @IBAction func loginWithFacebook(_ sender: UIButton) {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: [ .publicProfile,.email ], viewController: self) { loginResult in
           print(loginResult)
           
            switch loginResult{
            case .failed(let error):
                print("facebook login error = \(error)")
            case .cancelled:
                print("facebook login cancelled")
            case .success(granted: let grantdePermission, declined: let declindePermission, token: let accessToken):
                print("facebook login success")
                self.getFacebookDetails()
            }
            
       }
        
    }
    //get the user info which is login with facebook
    func getFacebookDetails(){
        //guard let _ = AccessToken.current else{return}
        let param = ["fields":"name, email , gender,age_range"]
        let graphRequest = GraphRequest(graphPath: "me",parameters: param)
        graphRequest.start { (urlResponse, requestResult, error) in
            
            if(error == nil){
                if let data:[String:Any] = requestResult as? [String:Any]{
                    print(data["email"]!)
                    Server().login(account: data["email"] as! String, password: "loginWithThirdParty", completion: {(result) in
                        
                        self.performSegue(withIdentifier: "loginGoToHome", sender: self)
                        
                        
                    })
                }
            }
        }
    }

}

