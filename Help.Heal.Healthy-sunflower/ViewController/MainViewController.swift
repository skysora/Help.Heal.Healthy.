//
//  MainViewController.swift
//  Help.Heal.Healthy
//
//  Created by YuMIng Haung on 2019/6/19.
//  Copyright © 2019 sunflower. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    let midBtn = UIButton(type: .custom)
    var isClick = false
    var account : String! = ""
    func creatButton(){
        let TAB_HEIGHT = self.tabBar.frame.height
        let TAB_WIDTH = self.tabBar.frame.width
//        midBtn.frame = CGRect(x: self.view.frame.width/2 - 26,y:self.view.frame.height - 100,width: 52,height: 52)
        
        midBtn.frame = CGRect(x: (TAB_WIDTH/2)-40,y:-(TAB_HEIGHT/2),width: 80,height: 80)
        midBtn.setBackgroundImage(UIImage(named: "mid"), for: .normal)
        //        midBtn.frame = CGRect(x: 100,y:100,width: 52,height: 52)
        self.tabBar.addSubview(midBtn)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! HomeViewController
        //把segue.destination強制轉型成需要的類型
        controller.account = account!
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //  初始化一些要用到的参数
        
        let WINDOW_HEIGHT = self.view.frame.height
        let TAB_HEIGHT = self.tabBar.frame.height
        let GRID_WIDTH = self.view.frame.width / 5
        //  遮罩层，用于遮挡原本的 TabBarItem
        let modalView = UIView()
        modalView.frame = CGRect(x:GRID_WIDTH * 2,y: WINDOW_HEIGHT - TAB_HEIGHT*1.5,width: GRID_WIDTH,height:  TAB_HEIGHT)
        modalView.backgroundColor = UIColor(red:249/255,green:249/255,blue:249/255,alpha:1.0)
        
        self.tabBarController?.tabBar.addSubview(modalView)
//        self.view.addSubview(modalView)
        creatButton()
        //  给按钮添加事件
        midBtn.addTarget(self, action:#selector(clickButton(_:)), for: .touchDown)
        // Do any additional setup after loading the view.
    }
    
    
    @objc func clickButton(_ btn:UIButton){
        // 設置按鈕背景色，讓他看起來有 highlighted 的效果
        midBtn.backgroundColor = .white
        // 跳轉至 tabBarController 相對應的索引值的
        self.selectedIndex = 1
        if(self.selectedIndex != 1){
            midBtn.setBackgroundImage(UIImage(named: "mid"), for: .normal)
        }
        else{
            midBtn.setBackgroundImage(UIImage(named: "mid-hight"), for: .normal)
        }
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        // 判斷點選的頁面 title 是否為 Home：true 按鈕背景色為白色；false 則為灰色。
        if (self.selectedIndex != 1) {
            //            midBtn.setBackgroundImage(UIImage(named: "mid"), for: .normal)
        } else {
            midBtn.setBackgroundImage(UIImage(named: "mid"), for: .normal)
        }
        
    }
}
