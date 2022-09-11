//
//  RegisteredStoryboardSegue.swift
//  Help.Heal.Healthy-sunflower
//
//  Created by YuMIng Haung on 2019/7/15.
//  Copyright © 2019 sunflower. All rights reserved.
//

import UIKit

class goLoginStoryboardSegue: UIStoryboardSegue {
    override func perform() {
        // 取得來源端和目的端的視圖
        let VCAView = self.source.view as UIView? // 來源端
        let VCBView = self.destination.view as UIView? // 目的端
        // 取得畫面的寬度與高度
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        
        // 設定目的端View的初始位置(View A frame位置下方一個屏幕高度的地方)
        VCBView?.frame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: screenHeight)
        
        // 取得App的key window並在來源端的View圖層上插入目的端的View
        let window = UIApplication.shared.keyWindow
        window?.insertSubview(VCBView!, aboveSubview: VCAView!)
        
        // 轉場的動畫
        UIView.animate(withDuration: 0.7, animations: { () -> Void in
            // 兩個視圖同時向上移動一個屏幕的高度
            VCAView?.frame = (VCAView?.frame)!.offsetBy(dx: screenWidth, dy: 0.0)
            VCBView?.frame = (VCBView?.frame)!.offsetBy(dx: screenWidth, dy: 0.0)
        }) { (finish) -> Void in
            // 無動畫的方式呈現目的端的視圖
            self.source.present(self.destination as UIViewController, animated: false, completion: nil)
        }
    }
}
