//
//  server.swift
//  Help.Heal.Healthy-sunflower
//
//  Created by YuMIng Haung on 2019/9/13.
//  Copyright © 2019 sunflower. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class Server{
    let serverIP: String
    var parameters: Parameters!
    init(sql: String){
        self.serverIP = sql
    }
    convenience init(select: Bool = true){
        if(select){
            self.init(sql: "http://140.134.26.219:8889")
        }
        else{
            self.init(sql: "http://140.134.26.219:8889")
        }
    }
    
    func login(account: String, password: String,completion:((_ result: Bool)->Void)?) {
        parameters = ["account": account, "password": password]
        var result : Bool = false
        let address = serverIP + "/login"
    Alamofire.request(address,method:.post,parameters:parameters,encoding:JSONEncoding.default,headers:["Content-Type":"application/json"]).responseJSON{
            response in
            do{
                if(response.result.isSuccess){

                    print("登入成功")
                    let res: JSON = try! JSON(data: response.data!)
                    //判斷post是否成功

                    if((res["LoginIsSuccess"]).boolValue){
                        result = true
                    }
                }else{

                    print("登入失敗")

                }
            }
            completion?(result)
        }
    }
    //建立本地端推播

    func setNotifiaction(account: String,completion:((_ result: Bool)->Void)?) {
        parameters = ["account": account]
        var result : Bool = false
        let notification = selfNotifications(account: account)
        let address = serverIP + "/mealNotificationOutput"

    Alamofire.request(address,method:.post,parameters:parameters,encoding:JSONEncoding.default,headers:["Content-Type":"application/json"]).responseJSON{
            response in
            do{
                if(response.result.isSuccess){

                    print("推播提醒更改成功")
                    let res: JSON = try! JSON(data: response.data!)
                    result = true
                    notification.mealNotification(title: res["title"].stringValue,
                                                       body: res["body"].stringValue,
                                                       hour: res["hour"].int!,
                                                       minute: res["minute"].int!)
                }else{
                    print("推播提醒更改失敗")

                }
            }
            completion?(result)
        }
    }

    //建立每週資料
    func getWeekData(account:String,completion:((_ countStepArray: [CGFloat],

                                                  _ caloriesArray: [CGFloat],
                                                  _ sleepArray: [CGFloat],
                                                  _ monthArray:[String],
                                                  _ flag:Bool)->Void)?){
        parameters = ["account": account,"date": "2019-12-26"]
        var countStepArray:[CGFloat] = [0,0,0,0,0,0,0]
        var caloriesArray:[CGFloat] = [0,0,0,0,0,0,0]
        var sleepStepArray:[CGFloat] = [0,0,0,0,0,0,0]
        var monthArray = ["一", "二", "三", "四", "五", "六", "日"]
        var flag :Bool = false

        let address =  serverIP + "/a_week_data"
    Alamofire.request(address,method:.post,parameters:parameters,encoding:JSONEncoding.default,headers:["Content-Type":"application/json"]).responseJSON{
                    response in
                    do{
                        if(response.result.isSuccess){
                            let res: JSON = try! JSON(data: response.data!)

                            for i in 0...6{
                                countStepArray[i] = CGFloat(res[i]["step"].doubleValue)
                                caloriesArray[i] =  CGFloat(res[i]["calories"].doubleValue)
                                sleepStepArray[i] = CGFloat(res[i]["sleep"].doubleValue)
                                if(countStepArray[i] == 0 ||
                                    caloriesArray[i] == 0 ||
                                    sleepStepArray[i] == 0){
                                    flag = true
                                }
        //                  回傳前七天的日期
                            monthArray[i] = res[i]["date"].stringValue
                            }
                        }else{
                            print("每週資料伺服器回傳錯誤")
                        }
                    }
                completion?(countStepArray,
                            caloriesArray,
                            sleepStepArray,
                            monthArray,
                            flag)
                }
        
    }

    
    //把辨識的食物傳入database

    func foodInsert(foodList:[String:Any]){
        var foodData:[String:Any] = foodList
        //foodData["foodName"] = foodList

        let url = serverIP + "/foodInput/" + accountForEverySwift
        //get the current time
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let time = String(hour) + ":" + String(minutes)
        foodData["time"] = time
        print(foodData)
        Alamofire.request(url, method: .post, parameters: foodData, encoding:JSONEncoding.default , headers: ["Content-Type":"application/json"])
        print("send to database")
    }
    //request food image
    func reqestFoodImage(foodName:String, completion:((_ result:UIImage)->Void)?){

        //把食物名稱中的空格換成_
        let newFoodName = foodName.replacingOccurrences(of: " ", with: "_")
        let url = serverIP + "/sendImage/" + newFoodName
        print(url)
        //DataRequest.addAcceptableImageContentTypes(["image/jpg"])
        Alamofire.request(url, method: .get).responseImage{responed in
            if let image = responed.result.value{
                completion?(image)
                

            }
            else{
                print("image requset fail")
            }
        }
    }

    //食物列表
    let foodNameTranslateDescription = ["Steak":"是西餐中最常見的食物之一。牛排的烹調方法以煎和燒烤為主。",
                             "Beef Noodles":"牛肉麵是泛指各種以燉煮過的牛肉為主要配料的湯麵食。",
                             "Dumpling":"餃子通常由碎肉和蔬菜餡料包裹成一片薄生麵團後包好密封。",
                             "Longan":"龍眼可治療貧血、心悸、失眠、健忘、神經衰弱及病後、產後身體虛弱等症。",
                             "Loquat":"枇杷富有各種果糖、葡萄糖、鉀、磷、鐵、鈣以及維生素A、B、C等。",
                             "Lychee":"荔枝果肉中含有維生素C、蛋白質、脂肪、磷、鈣、鐵等成分。",
                             "Dongpo Pork":"江、浙菜名，用五花肉燉製而成。",
                             "Steamed Lotus Root":"藕微甜而脆，可生食也可做菜。",
                             "Tangyuan": "湯圓是一個盛行於華人界的美食及甜點。",
                             "Fired Cabbage" : "高麗菜是維生素C和植物纖維的良好來源。",
                             "Fired Cauliflower":"花椰菜富含維生素B群、C。",
                             "Milk": "牛奶，是最古老的天然飲料之一。",
                             "Yogurt" : "優格中含有的嗜熱鏈球菌和保加利亞乳桿菌活體成分對人類健康有益。",
                             "ButterMilk" : "以普通優格為原料，經添加其他非乳成份再行加工製成，濃度一般較稀，流動性好。",
                             "Pistachio" : "開心果富含維生素A、維生素E。",
                             "Sunflower Seeds" : "葵花籽是指向日葵的果實 （連殼）或種子（去殼後）",
                             "Almond" : "杏仁脂肪高但卻可提高身體能量代謝，促進脂肪消耗能量。"]
    
    func getFoodList(account:String,completion:((_ result: [Meal])->Void)?) {
        let now:Date = Date()
        let dateFormat:DateFormatter = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        let dateString:String = dateFormat.string(from: now)
        print(dateString)
        parameters = ["account": account,"date": dateString]

        var count = 0
        let address =  serverIP + "/foodList"
            
    Alamofire.request(address,method:.post,parameters:parameters,encoding:JSONEncoding.default,headers:["Content-Type":"application/json"]).responseJSON{
            response in
            var meal : [Meal] = []
//            print(response)
            do{
                if(response.result.isSuccess){
    //          實際資料
                let res: JSON = try! JSON(data: response.data!)
                    meal.append(Meal(name: "早餐"))
                    for data in res["breakfast"]{
                        count = count + 1
                    meal.append(
                        Meal(name: self.foodNameTranslate[data.1["foodName"].stringValue]!, amount: "null", calories: "null",
                             fruit: data.1["fruit"].intValue, nut: data.1["nut"].intValue,
                             milk: data.1["milk"].intValue, meat: data.1["meat"].intValue,
                             rice: data.1["rice"].intValue, vegetable: data.1["vegetable"].intValue,
                             image: UIImage(named: data.1["foodName"].stringValue)!))
                        meal[count].setImage(image: UIImage(named: data.1["foodName"].stringValue )!)
//                        self.reqestFoodImage(foodName: data.1["foodName"].stringValue, completion: {
//                            result in
//                            meal[count-1].setImage(image: result)
//                        })
                    }
//                    if(meal.count == 1){
//                        meal.popLast()
//
//                    }
                    let breakfastCount = meal.count
                    meal.append(Meal(name: "午餐"))
                    for data in res["lunch"]{
                        count = count + 1
                        meal.append(
                        Meal(name: self.foodNameTranslate[data.1["foodName"].stringValue]!,
                             amount: "null", calories: "null",
                             fruit: data.1["fruit"].intValue, nut: data.1["nut"].intValue,
                             milk: data.1["milk"].intValue, meat: data.1["meat"].intValue,
                             rice: data.1["rice"].intValue, vegetable: data.1["vegetable"].intValue,
                             image: UIImage(named: "rice")!))
                        meal[count].setImage(image: UIImage(named: data.1["foodName"].stringValue)!)
                    }
//                    if(meal.count == breakfastCount + 1 ){
//                        meal.popLast()
//                    }
                    meal.append(Meal(name: "晚餐"))
                    for data in res["dinner"]{
                        count = count + 1
                        meal.append(
                        Meal(name: self.foodNameTranslate[data.1["foodName"].stringValue]!,
                             amount: "null", calories: "null",
                             fruit: data.1["fruit"].intValue, nut: data.1["nut"].intValue,
                             milk: data.1["milk"].intValue, meat: data.1["meat"].intValue,
                             rice: data.1["rice"].intValue, vegetable: data.1["vegetable"].intValue,
                             image: UIImage(named: data.1["foodName"].stringValue)!))
                    }
                    }else{
                        print("伺服器回傳錯誤")
                    }
                }
         completion!(meal)
            }
        }
    
    let foodNameTranslate = ["Steak":"牛排","Beef Noodles":"牛肉麵",
                                        "Dumpling":"水餃","Longan":"龍眼",
                                        "Loquat":"枇杷","Lychee":"荔枝",
                                        "Dongpo Pork":"東坡肉",
                                        "Steamed Lotus Root":"蒸蓮藕",
                                        "Tangyuan":"湯圓",
                                        "Fired Cabbage" : "炒高麗菜",
                                        "Fired Cauliflower":"炒花椰菜",
                                        "Milk": "牛奶",
                                        "Yogurt" : "優格",
                                        "ButterMilk" : "優酪乳",
                                        "Pistachio" : "開心果",
                                        "Sunflower Seeds" : "葵花籽",
                                        "Almond" : "杏仁"]
    
    //地區食物推薦
        func getMealRecommend(account:String,completion:((_ result: [recommend])->Void)?) {
            parameters = ["account": account]
            let address =  serverIP + "/foodRecommend"
            var data :[recommend] = []
            var count = 0
        Alamofire.request(address,method:.post,parameters:parameters,encoding:JSONEncoding.default,headers:["Content-Type":"application/json"]).responseJSON{
                response in
            
                do{
                    if(response.result.isSuccess){
                        let res: JSON = try! JSON(data: response.data!)
                        for i in res["recommend"]{
                            count = count + 1
                            data.append(recommend(name: self.foodNameTranslate[i.1.stringValue]!,
                                                  description: self.foodNameTranslateDescription[i.1.stringValue]!,
                                      image: UIImage(named: "rice")!))
                            data[count-1].setImage(image: UIImage(named: i.1.stringValue)!)
                        

                        }
                    }else{
                        print("伺服器回傳錯誤")
                    }
                }
            completion!(data)
            }
    }
    //公告
    func getPost(completion:((_ result: [PostMessage])->Void)?){
        let address =  serverIP + "/announcement"
        var data :[PostMessage] = []
        Alamofire.request(address,method: .get,encoding:JSONEncoding.default).responseJSON(completionHandler: {
            response in
            if(response.result.isSuccess){
                print("公告接收成功")
                let res: JSON = try! JSON(data: response.data!)
                for i in res.arrayValue{
                    data.append(PostMessage(title: i["title"].string!, date: i["date"].string!, document: i["document"].string!))
                }
            }else{
                print("fail to get post data")
            }
            completion!(data)
        })
        
    }
    
    
    
    
    
    

}
