//
//  IngredientClassification.swift
//  Help.Heal.Healthy-sunflower
//
//  Created by YuMing Haung on 2019/10/14.
//  Copyright © 2019 sunflower. All rights reserved.
//
import UIKit
import Foundation
class IngredientClassification {
    let progress : UIProgressView
    let label : UILabel
    var image : UIImageView
    init(progress : UIProgressView,
         label:UILabel,
         image:UIImageView){
        self.progress = progress
        self.label = label
        self.image = image
        
    }
    func setImage(image:UIImageView){
        self.image = image
    }
    func setPosition(X_origin:Int,Y_origin:Int,progress_heightInterval:Int,
                     progress_widthInterval:Int,progress_width:Int,progress_height:Int,
                     i:Int,j:Int){
        
        //設定顯示條
        progress.frame = CGRect(x: X_origin + (j*progress_widthInterval),y: Y_origin + (i*progress_heightInterval) ,width: progress_width,height: progress_height)
        //設定文字
        label.frame = CGRect(x: Int(progress.center.x) - Int(progress_width/2),y: Y_origin + (i*progress_heightInterval)-20 ,width: progress_width,height: 5)
        label.font =  UIFont(name: "Helvetica-Light", size: 15)
        label.textAlignment = NSTextAlignment.center
        //設定圖片
        image.frame = CGRect(x: Int(progress.center.x) - Int(Double(progress_width)*(1.2))/2,y: Y_origin + (i*progress_heightInterval)-100 ,width: Int(Double(progress_width)*(1.2)),height: Int(Double(progress_width)*(1.2)))
        label.adjustsFontSizeToFitWidth = true
    }
    func plusData(data:Float){
        progress.progress = progress.progress + data
        progress.trackTintColor = .gray
        progress.transform = CGAffineTransform(scaleX: 1.0, y: 3.0)
        if progress.progress < 0.7 {
            progress.progressTintColor = #colorLiteral(red: 1, green: 0.6098514711, blue: 0, alpha: 1)
        }
        else if progress.progress < 1.1{
            progress.progressTintColor = #colorLiteral(red: 0.4767136495, green: 1, blue: 0, alpha: 1)
            }
        else{
            progress.progressTintColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
        }
        progress.layer.cornerRadius = 5
        progress.clipsToBounds = true
        progress.setProgress(progress.progress, animated:true)
        }
}
