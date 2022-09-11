//
//  HomeViewController.swift
//  Help.Heal.Healthy
//
//  Created by YuMIng Haung on 2019/6/21.
//  Copyright © 2019 sunflower. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import HealthKit
import CareKit
class HomeViewController: UIViewController,UIScrollViewDelegate{
    @IBOutlet weak var line: UIView!
    @IBOutlet weak var analysisView: UIScrollView!
    @IBOutlet weak var Date: UIButton!
    @IBOutlet weak var Week: UIButton!
    var account : String! = ""
    var pageNum : Int! = 0
    var health : HealthData!
    override func viewDidLoad() {
        super.viewDidLoad()
        analysisView.delegate = self
        line.layer.cornerRadius = 5
        pageNum = Int(round(analysisView.contentOffset.x / analysisView.frame.size.width))

        convertCircle()
        health = HealthData()
        health.setAccount(user: account)
        updateFirstViewLabel()
//        buildChart()
        
    }
    func convertCircle(){
        stepCountView.layer.cornerRadius = stepCountView.frame.width/2
        caloriesView.layer.cornerRadius = caloriesView.frame.width/2
        sleepView.layer.cornerRadius = sleepView.frame.width/2
        stepCountBtn.layer.cornerRadius = stepCountBtn.frame.width/2
        sleepBtn.layer.cornerRadius = sleepBtn.frame.width/2
        caloriesBtn.layer.cornerRadius = caloriesBtn.frame.width/2
        smallSleepLabel.text = ""
        
    }
    // 滑動時
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = analysisView.contentOffset.x / analysisView.frame.size.width
        pageNum = Int(round(analysisView.contentOffset.x / analysisView.frame.size.width))
        if(offset == 1.0){
            acceptWeekData()
        }
        switch pageNum {
        case 0:
            //iphone XR
           self.line.center.x = (Date.center.x) + (Date.frame.width)*1.5
        case 1:
            //iphone XR
            self.line.center.x = (Week.center.x) + (Week.frame.width)*1.5
        default:
            self.line.center.x = analysisView.contentOffset.x
        }
    }
  
    //FirstView
    @IBOutlet weak var stepCountView: UIView!
    @IBOutlet weak var stepCountBtn: UIButton!
    @IBOutlet weak var stepCountLabel: UILabel!
    @IBOutlet weak var sleepBtn: UIButton!
    @IBOutlet weak var sleepView: UIView!
    @IBOutlet weak var sleepLabel: UILabel!
    @IBOutlet weak var caloriesView: UIView!
    @IBOutlet weak var caloriesBtn: UIButton!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var smallSleepLabel: UILabel!
    
    @IBAction func mealRecommend(_ sender: UIButton) {
        self.performSegue(withIdentifier: "mealRecommend", sender: self)
    }
    @IBAction func WarnBtn(_ sender: UIButton) {
        self.performSegue(withIdentifier: "warn", sender: self)
    }
    @IBAction func sharingBtn(_ sender: UIButton) {
        self.performSegue(withIdentifier: "sharing", sender: self)
    }
    @IBAction func ingredientBtn(_ sender: UIButton) {
        self.performSegue(withIdentifier: "ingredient", sender: self)
    }
    @IBAction func postBtn(_ sender: UIButton) {
        self.performSegue(withIdentifier: "post", sender: self)
    }
    @IBAction func dataOutput(_ sender: UIButton) {
        self.performSegue(withIdentifier: "dataOutput", sender: self)
    }
    func updateFirstViewLabel(){
        //顯示步數
        health.getTodaysSteps(){
            (result) in
            DispatchQueue.main.async {
                self.stepCountLabel.text = "\(Int(result))"
            }
        }
        //判斷睡眠時間
        health.getSleepAnalysis(){
            (result,number) in
            if(number <= 8){
                self.sleepLabel.text = "缺乏"
                self.smallSleepLabel.text = "只睡了\(String(number))小時"
                self.sleepLabel.textColor = .red
            }else{
                self.sleepLabel.text = "達成"
                self.sleepLabel.center.x = self.sleepView.frame.width/2
                self.sleepLabel.center.y = self.sleepView.frame.height/2
            }
        }
    }
    //        let url = 定期跟server要卡路里資料
    //        Alamofire.request(url,method: .get,encoding:JSONEncoding.default).responseJSON(completionHandler: {
    //            response in
    //            //成功
    //            if(response.result.isSuccess){
    //                let res: JSON = try! JSON(data: response.data!)
    //
    //            }else{
    //                print("error")
    //            }
    //        })
    
    //SecondView
    let server = Server()
    @IBOutlet weak var secondView: UIView!

    func acceptWeekData(){
        server.getWeekData(account: accountForEverySwift){
            (serverCountStepArray,serverCaloriesArray,serverSleepStepArray,serverMonthArray,serverFlag) in
            self.buildChart(countStepArray: serverCountStepArray,caloriesArray: serverCaloriesArray,
                       sleepStepArray: serverSleepStepArray,monthArray: serverMonthArray,flag: serverFlag)
        }
    }
    func alertNoData(){
        let controller = UIAlertController(title: "您的資料不夠完整", message: "完整的紀錄三餐資料才會完整哦～", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "好", style: .default, handler: nil)
        controller.addAction(okAction)
        present(controller, animated: true, completion: nil)
       
    }
    func buildChart(countStepArray:[CGFloat],caloriesArray:[CGFloat],sleepStepArray:[CGFloat],
                    monthArray:[String],flag:Bool){
        //沒資料的時候後提醒
        if(!flag){
            self.alertNoData()
        }
        //建立secondView內的scrollView規則
        let background = UIView()
        background.frame = CGRect(x: 0,y: 0 ,width: self.secondView.frame.width,
                                             height: 1000)
        let secondscrollView = UIScrollView(frame: view.bounds)
        secondscrollView.contentSize = background.bounds.size
        secondscrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        //建立圖表
        let Chart_width = Int(self.secondView.frame.width) - 50
        let Chart_height = 200
        let Chart_X = (Int(self.secondView.frame.width)/2) - (Chart_width/2)
        let Chart_Y = 50
        
        let countStepsChart = OCKCartesianChartView(type: .bar)
        countStepsChart.headerView.titleLabel.text = "步數"
        countStepsChart.graphView.dataSeries =  [OCKDataSeries(values: countStepArray, title: "步數")]
        countStepsChart.graphView.horizontalAxisMarkers = monthArray
        countStepsChart.frame = CGRect(x: Int(Chart_X),y: 3*Chart_Y+2*Chart_height ,width: Chart_width,height: Chart_height)
    
        let caloriesChart = OCKCartesianChartView(type: .bar)
        caloriesChart.headerView.titleLabel.text = "卡路里"
        caloriesChart.headerView.detailLabel.text = "暫時顯示不出來"
        caloriesChart.graphView.dataSeries =  [OCKDataSeries(values: caloriesArray, title: "卡路里")]
        caloriesChart.graphView.horizontalAxisMarkers = monthArray
        caloriesChart.frame = CGRect(x: Int(Chart_X),y: Chart_Y ,width: Chart_width,height: Chart_height)
        
        let sleepChart = OCKCartesianChartView(type: .bar)
        sleepChart.headerView.titleLabel.text = "睡眠時數"
        sleepChart.graphView.dataSeries =  [OCKDataSeries(values: sleepStepArray, title: "睡眠時數")]
        sleepChart.graphView.horizontalAxisMarkers = monthArray
        sleepChart.frame = CGRect(x: Int(Chart_X),y: 2*Chart_Y+Chart_height ,width: Chart_width,height: Chart_height)
        
        background.addSubview(caloriesChart)
        background.addSubview(sleepChart)
        background.addSubview(countStepsChart)
        //添加到視圖
        secondscrollView.addSubview(background)
        self.secondView.addSubview(secondscrollView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "Ingredient" {
            let controller = segue.destination as! IngredientViewController
            controller.bool = false
        }
    }
}



