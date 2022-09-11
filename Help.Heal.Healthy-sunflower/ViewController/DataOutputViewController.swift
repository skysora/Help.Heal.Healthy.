//
//  DataOutputViewController.swift
//  Help.Heal.Healthy-sunflower
//
//  Created by iMac01 on 2019/7/20.
//  Copyright © 2019 sunflower. All rights reserved.
//
import Alamofire
import AlamofireImage
import UIKit

class DataOutputViewController: UIViewController {
    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = ""
        //DataRequest.addAcceptableImageContentTypes(["image/jpg"])//要自己加content-type
        let data = ["account" : accountForEverySwift]
        Alamofire.request(url,method: .post, parameters: data,encoding:JSONEncoding.default).responseImage{
            response in
            debugPrint(response)
//            print(response.request)
//            print(response.response)
            if let img = response.result.value{
                print("success to get image")
                self.image.image = img
            }
            //self.image.image = UIImage(data:data , scale: 1)
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to th/Users/yuminghaung/Desktop/Help.Heal.Healthy/Help.Heal.Healthy-sunflower/ViewController/MealRecommend/MealRecommendViewController.swifte new view controller.
    }
    */

}
