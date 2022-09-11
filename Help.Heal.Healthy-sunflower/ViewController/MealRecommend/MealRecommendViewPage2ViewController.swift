//
//  MealRecommendViewPage2ViewController.swift
//  Help.Heal.Healthy-sunflower
//
//  Created by YuMIng Haung on 2019/7/22.
//  Copyright © 2019 sunflower. All rights reserved.
//

import UIKit

class MealRecommendViewPage2ViewController: UIViewController,UITableViewDelegate , UITableViewDataSource {
    let server = Server()
    override func viewDidLoad() {
        super.viewDidLoad()
        setMealTableView()
        dialogLabel.text = "為您推薦以上"
        dialog.layer.cornerRadius = 20
    }
    
    @IBOutlet weak var dialog: UIView!
    
    
    @IBOutlet var backGroundview: UIView!
    @IBOutlet weak var dialogLabel: UILabel!
    var meal : [recommend] = []
    var mealTableView  = UITableView()
    func setMealTableView() -> Void {
        //授權
        self.mealTableView.register(UINib(nibName: "MealTableViewCell", bundle: nil), forCellReuseIdentifier: "mealTableViewCell")
        self.mealTableView.register(UINib(nibName: "LabelTableViewCell", bundle: nil), forCellReuseIdentifier: "labelTableViewCell")
        mealTableView.delegate = self
        mealTableView.dataSource = self
        mealTableView.frame = CGRect (x:0,y:140,width: self.backGroundview.bounds.width, height:  CGFloat((3)*100))
//        mealTableView.separatorStyle = .none //線條systle
        mealTableView.estimatedRowHeight = 0
        self.backGroundview.addSubview(mealTableView)
        server.getMealRecommend(account: accountForEverySwift, completion: {
            (result) in
            self.meal = result
            self.mealTableView.reloadData()
        })
        
    }
    
    //talbeView cell數量
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (self.meal.count)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    //talbeView cell點擊動作
    func tableView(_ tableView: UITableView,didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        mealTableView.rowHeight = 100
        let cell = tableView.dequeueReusableCell(withIdentifier: "mealTableViewCell") as! MealTableViewCell
        cell.mealAmount.text = ""
        cell.mealName.text = self.meal[indexPath.row].name
        cell.mealCalorie.text = ""
        cell.mealDescription.text = self.meal[indexPath.row].description
        cell.imageView?.image = self.meal[indexPath.row].image
        cell.backgroundColor = #colorLiteral(red: 0.9994691014, green: 0.9527079463, blue: 0.8476769328, alpha: 1)
        cell.mealDescription.adjustsFontSizeToFitWidth = true
            return cell
    }
    
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
