//
//  IngredientViewController.swift
//  Help.Heal.Healthy
//
//  Created by iMac01 on 2019/7/7.
//  Copyright © 2019 sunflower. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class IngredientViewController: UIViewController,UITableViewDelegate , UITableViewDataSource{
    //, UITableViewDelegate , UITableViewDataSource
    let server = Server()
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var ingredView: UIView!
    var scrollOption : InfiniteScrollView!
    let mealTableView = UITableView(frame: CGRect(x: 0, y: 20, width: 300, height:100), style: .grouped)
    
    
    @IBOutlet weak var TopLeftOutView: UIView!
    @IBOutlet weak var TopLeftView: UIView!
    @IBOutlet weak var TopLeftLabel: UILabel!
    @IBOutlet weak var TopLeftNumber: UILabel!
    
    @IBOutlet weak var TopRightOutView: UIView!
    @IBOutlet weak var TopRightView: UIView!
    @IBOutlet weak var TopRightLabel: UILabel!
    @IBOutlet weak var TopRightNumber: UILabel!
    
    @IBOutlet weak var TopLabelOutView: UIView!
    @IBOutlet weak var TopLabelView: UIView!
    @IBOutlet weak var TopLabel: UILabel!
    @IBOutlet weak var TopNumber: UILabel!
    
    @IBOutlet weak var DateTopic: UILabel!
    @IBOutlet weak var whitepoint: UIView!
    //ctach the data pass by foodSearchViewController
    var bool = true
    var totalCalorie: Double = 0
    var totalWater: Double = 0
    var totalProtein: Double = 0
    var totalCarbonhydrate: Double = 0
    var totalFat: Double = 0
    var totalSugar: Double = 0
    var totalSalt: Double = 0
    @IBOutlet  var firstView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMealTableView()
        setClassification()
        
        
        self.scrollOption = InfiniteScrollView(frame: CGRect(x:0,y:120,width: self.view.bounds.width, height: 40))
        self.scrollOption.datasource = ["一","二","三","四","五","六","日"]
        self.view.addSubview(scrollOption)
        scrollOption.scrollView.delegate = self
        
        ingredView.layer.cornerRadius = ingredView.bounds.width / 5
        ingredView.clipsToBounds = true
        ingredView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        
        ViewToCircle(View:TopLeftOutView)
        ViewToCircle(View:TopLeftView)
        ViewToCircle(View:TopRightOutView)
        ViewToCircle(View:TopRightView)
        ViewToCircle(View:TopLabelOutView)
        ViewToCircle(View:TopLabelView)
        

        
        TopLabel.text = "本日剩餘"
        TopLeftLabel.text = "已經攝取"
        TopRightLabel.text = "運動消耗"
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM/dd"
        DateTopic.text = "今天" + dateFormat.string(from: Date())
        dateFormat.dateFormat = "yyyy-MM-dd"
        calculationEnergy()
        
//        let url = "http://140.134.26.159:5000/dateInfo/" + accountForEverySwift + "/" + dateFormat.string(from: Date())
//        Alamofire.request(url,method: .get,encoding:JSONEncoding.default).responseJSON(completionHandler: {
//            response in
//            if(response.result.isSuccess){
//                print("susses")
//                let res: JSON = try! JSON(data: response.data!)
//                //判斷get是否成功
//                if(res["calories"].int! >= 2000){
//                    self.TopNumber.text = "0"
//                }
//                else{
//                self.TopNumber.text = String(2000 - res["calories"].int!)
//                }
//                self.TopLeftNumber.text = res["calories"].stringValue
//                self.TopRightNumber.text = ""
//            }
//            else{
//                print("fail to get dataInfo")
//            }
//        })
        
       
        
        
//        whitepoint.clipsToBounds = true
//        whitepoint.layer.cornerRadius = 2.5
//        
//        // Do any additional setup after loading the view.
//        //navigationController?.viewControllers = [FoodSearchViewController(), self]
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.view.backgroundColor = .clear
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let storyboard = UIStoryboard(name: "FoodSearch", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FoodSearch")
        var viewcontrollers = self.navigationController?.viewControllers
        viewcontrollers?.removeAll()
        viewcontrollers?.insert(vc, at: 0)
        self.navigationController?.setViewControllers(viewcontrollers!, animated: true)
        
    }
    
    func calculationEnergy(){
        let health = HealthData()
        health.getTodaysSteps(){
            (result) in
            let energy = result * 0.033
            self.TopRightNumber.text = "\(Int(energy))"
            
        }
    }
    let classIdgredient = ["egg","rice","fruit","salt","rice","vegetable","other"]
    let ChineseclassIdgredient = ["蛋白質","碳水化合物","維生素","鹽類","纖維素","其他"]
    var classificationArray : [IngredientClassification] = []
    func  setClassification(){
        let progress_width = 60
        let progress_height = 5
        let progress_heightInterval = 130
        let progress_widthInterval = 100
        let X_origin = Int(self.firstView.frame.width/2) - ((progress_widthInterval*2) + (progress_width))/2
        let Y_origin = 150
        
        var count = 0
        for i in 0..<2{
            for j in 0..<3{
                let temp = IngredientClassification(progress: UIProgressView(progressViewStyle: .bar),
                                                    label:UILabel(),
                                                    image: UIImageView(image: UIImage(named: classIdgredient[count])))
                temp.plusData(data: Float.random(in: 0...0.7))
                temp.label.text = ChineseclassIdgredient[count]
                temp.setPosition(X_origin:X_origin,
                                 Y_origin:Y_origin,
                                 progress_heightInterval:Int(progress_heightInterval),
                                 progress_widthInterval:progress_widthInterval,
                                 progress_width:progress_width,
                                 progress_height:progress_height,
                                 i:i,
                                 j:j)
                temp.progress.transform = temp.progress.transform.scaledBy(x: 1, y: 3)
                
                classificationArray.append(temp)
                self.firstView.addSubview(classificationArray[count].progress)
                self.firstView.addSubview(classificationArray[count].label)
                self.firstView.addSubview(classificationArray[count].image)
                count = count + 1
                
            }
        }
        
    }
    
    func ViewToCircle(View:UIView){
        View.layer.cornerRadius = View.bounds.width / 2
        View.clipsToBounds = true
    }
    
    
    
    
    
    
    
    //second
    var meal : [Meal] = []
    var imageArray : [UIImage] = []
    func setMealTableView() -> Void {
        //授權
        self.mealTableView.register(UINib(nibName: "MealTableViewCell", bundle: nil), forCellReuseIdentifier: "mealTableViewCell")
        self.mealTableView.register(UINib(nibName: "LabelTableViewCell", bundle: nil), forCellReuseIdentifier: "labelTableViewCell")
        mealTableView.delegate = self
        mealTableView.dataSource = self

        mealTableView.backgroundColor = .white
        mealTableView.separatorStyle = .none //線條systle
        self.secondView.addSubview(mealTableView)
        mealTableView.estimatedRowHeight = 0
        
        server.getFoodList(account: accountForEverySwift, completion:{
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
        mealTableView.frame = CGRect (x:0,y:30,width: self.secondView.bounds.width, height:  CGFloat((4)*100))
        if(self.meal[indexPath.row].fruit == -1 ){
            mealTableView.rowHeight = 50
            let cell = tableView.dequeueReusableCell(withIdentifier: "labelTableViewCell") as! LabelTableViewCell
            cell.Label.text = self.meal[indexPath.row].name!
            return cell
        }else{
            mealTableView.rowHeight = 100
            let cell = tableView.dequeueReusableCell(withIdentifier: "mealTableViewCell") as! MealTableViewCell
            cell.mealAmount.text = self.meal[indexPath.row].amount
            cell.mealName.text = self.meal[indexPath.row].name
            cell.mealCalorie.text = self.meal[indexPath.row].calories
            cell.mealImagle.image = self.meal[indexPath.row].image
            return cell
        }
    }
}
extension  IngredientViewController :UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard self.scrollOption._datasource != nil else {return}
        let x = scrollView.contentOffset.x
        if x  >= scrollView.contentSize.width - scrollView.frame.size.width - 1 {//設定當contentoffset 顯示 五
            self.scrollOption.scrollView.contentOffset = CGPoint(x: scrollView.frame.width / 7 , y: 0)//跳回五
        }
        else if x <= 1  {
            self.scrollOption.scrollView.contentOffset = CGPoint(x: scrollView.frame.width, y: 0)
        }
    }
}
