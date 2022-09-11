//
//  DetailViewController.swift
//  Help.Heal.Healthy
//
//  Created by Ａlvin on 2019/7/4.
//  Copyright © 2019 sunflower. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class FoodDetailViewController: UIViewController {
    
    
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var calorie: UILabel!
    @IBOutlet weak var water: UILabel!
    @IBOutlet weak var protein: UILabel!
    @IBOutlet weak var carbonhydrate: UILabel!
    @IBOutlet weak var fat: UILabel!
    @IBOutlet weak var sugar: UILabel!
    @IBOutlet weak var salt: UILabel!
    
    //cautch the passing data from foodInsertViewController
    var foodImagePassing = UIImage()
    var foodNamePassing = String()
    var foodSizePassing = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.title = ""
        let url = "http://140.134.26.159:5000/foodInfo/" + foodNamePassing
        //reqest JSON
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default).responseJSON(completionHandler: {response in
            
            if(response.result.isSuccess){
                let data:JSON = try! JSON(data: response.data!)
                print(data)
                self.calorie.text = self.calorie.text! + String(data["calories"].doubleValue * self.foodSizePassing)
                self.water.text = self.water.text! + String(data["water"].doubleValue * self.foodSizePassing)
                self.protein.text = self.protein.text! + String(data["protein"].doubleValue * self.foodSizePassing)
                self.carbonhydrate.text = self.carbonhydrate.text! + String(data["CnH2nOn"].doubleValue * self.foodSizePassing)
                self.fat.text = self.fat.text! + String(data["fat"].doubleValue * self.foodSizePassing)
                self.sugar.text = self.sugar.text! + String(data["sugar"].doubleValue * self.foodSizePassing)
                self.salt.text = self.salt.text! + String(data["salt"].doubleValue * self.foodSizePassing)
            }
            else{
                print("No respone")
            }
        })
        foodImage.image = foodImagePassing
        foodImage.layer.cornerRadius = 20
        foodImage.contentMode = .scaleAspectFill
        foodName.text = foodName.text! + foodNameTranslate[foodNamePassing]!
        
    }
    
    @IBAction func addFood(_ sender: UIButton) {
        
    }
    
 
    @IBAction func backButton(_ sender: UIButton) {
        performSegue(withIdentifier: "goToFoodInsert", sender: self)
    }
    
}
