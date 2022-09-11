//
//  HealthData.swift
//  Help.Heal.Healthy-sunflower
//
//  Created by YuMIng Haung on 2019/7/9.
//  Copyright © 2019 sunflower. All rights reserved.
//

import Foundation
import HealthKit
import Alamofire
import SwiftyJSON
class HealthData{
    //HealthKit
    let healthStore = HKHealthStore()
    var account:String
    func setAccount(user:String){
        self.account = user
    }
    
    init() {
        let allTypes = Set([HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
                            HKObjectType.quantityType(forIdentifier: .stepCount)!,
                            HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!,
                            HKObjectType.workoutType()])
        healthStore.requestAuthorization(toShare: allTypes, read: allTypes) { (success, error) in
            guard success else{
                print("授權失敗")
                return
            }
        }
        self.account = ""
    }
//    func getActiveEnergyBurned(completion: @escaping (Double) -> Void){
//        let activeEnergyBurned = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
//        let now = Date()
//        var totalBurnedEnergy = Double()
//        //  Set the Predicates
//        let startOfDay = Calendar.current.startOfDay(for: now)
//        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
//        
//        let query = HKSampleQuery(sampleType: activeEnergyBurned, predicate: predicate, limit: 0, sortDescriptors: nil, resultsHandler: {
//            (query, results, error) in
//            if results == nil {
//                print("There was an error rDunning the query: \(String(describing: error))")
//            }
//            
//            DispatchQueue.main.async {
//                for activity in results as! [HKQuantitySample]
//                {
//                    let calories = activity.quantity.doubleValue(for: HKUnit.kilocalorie())
//                    totalBurnedEnergy = totalBurnedEnergy + calories
//                }
//                completion(totalBurnedEnergy)
//            }
//        })
//        self.healthStore.execute(query)
//    }
    func getTodaysSteps(completion: @escaping (Double) -> Void) {
        
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (_, result, error) in
            var resultCount = 0.0
            guard let result = result else {
                print("獲得步數失敗")
                completion(resultCount)
                return
            }
            if let sum = result.sumQuantity() {
//                print(sum.doubleValue(for: HKUnit.count()))
                resultCount = sum.doubleValue(for: HKUnit.count())
            }
            
            DispatchQueue.main.async {
                completion(resultCount)
            }
        }
        healthStore.execute(query)
        
    }
    func getSleepAnalysis(completion: @escaping ([String],Int) -> Void) {
        // first, we define the object type we want
        if let sleepType = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis) {
            // Use a sortDescriptor to get the recent data first
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
            // we create our query with a block completion to execute
            let query = HKSampleQuery(sampleType: sleepType, predicate: nil, limit: 50, sortDescriptors: [sortDescriptor]) { (query, tmpResult, error) -> Void in
                let date = Date()
                var completeData:[String] = []
                var today :Int = Calendar.current.dateComponents(in: TimeZone.current, from: date).day!
                if error != nil {
                    print("失敗得到睡眠資訊")
                    return
                }
                if let result = tmpResult {
                    print("成功得到睡眠資訊")
                    // do something with my data
                    var timeIntervalMax : Int = 0
                    var flag = 0
                    var lastDay:Int = Calendar.current.dateComponents(in: TimeZone.current, from: date).day!
                    var currentDate:String  = ""
                    for item in result {
                        if let sample = item as? HKCategorySample {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
                            let (result:difference,other:timeInterval) = self.getDifference(startTime:self.getTheDate(date: sample.startDate),endTime:self.getTheDate(date: sample.endDate))
                            //time是要比較長短的，str是要儲存的時間，day是來判斷哪一天的
                            let day = Calendar.current.dateComponents([.year,.month, .day, .hour,.minute,.second], from: sample.endDate)
                            if(lastDay != day.day!){
                                completeData.append(currentDate)
                                flag = 0
                            }else if(today == lastDay){
                                today = timeInterval/60/60
                            }
                            if(flag == 0){
                                lastDay = day.day!
                                timeIntervalMax = timeInterval
                                flag = 1
                                currentDate = difference
                            }else{
                                //不是第一次而且時間比較長
                                if(timeInterval>timeIntervalMax){
                                    timeIntervalMax = timeInterval
                                    currentDate = difference
                                }
                            }
                        }
                        
                    }
                }
                DispatchQueue.main.async {
                    completion(completeData,today)
                }
            }
            // finally, we execute our query
            healthStore.execute(query)
        }
    }
    func getDifference(startTime:String,endTime:String) ->(result:String, other:Int){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        //把字串轉乘Date形式
        let date1 = dateFormatter.date(from: startTime)
        let date2 = dateFormatter.date(from: endTime)
        let difference = Calendar.current.dateComponents([.year,.month, .day, .hour,.minute,.second], from: date1!, to: date2!)
        let number = date2?.timeIntervalSince(date1!)
        let date22 = Calendar.current.dateComponents([.year,.month, .day, .hour,.minute,.second], from: date2!)
        let str = "\(date22.year!)-\(date22.month!)-\(date22.day!) \(difference.hour!):\(difference.minute!):\(difference.second!)"
        return (self.getTheDate(date: dateFormatter.date(from: str)!),Int(number!))
    }
    
    func upLoadData(sleepData:[String]) -> String {
        
        
        
        return ""
    }
    
    func getDay(date:Date!) -> Int
    {
        let calender = Calendar.current
        return calender.dateComponents(in: TimeZone.current, from: date).day!
    }
    func getMonth(date:Date!) -> Int
    {
        let calender = Calendar.current
        return calender.dateComponents(in: TimeZone.current, from: date).month!
    }
    func getYear(date:Date!) -> Int
    {
        let calender = Calendar.current
        return calender.dateComponents(in: TimeZone.current, from: date).year!
    }
    
    func getHour(date:Date!) -> Int
    {
        let calender = Calendar.current
        return calender.dateComponents(in: TimeZone.current, from: date).hour!
    }
    func getMinutes(date:Date!) -> Int
    {
        let calender = Calendar.current
        return calender.dateComponents(in: TimeZone.current, from: date).minute!
    }
    func getSecond(date:Date!) -> Int
    {
        let calender = Calendar.current
        return calender.dateComponents(in: TimeZone.current, from: date).second!
    }
    
    func getTheDate(date:Date!) -> String
    {
        let calender = Calendar.current
        return "\(getYear(date: date))-\(getMonth(date: date))-\(getDay(date: date)) \(calender.dateComponents(in: TimeZone.current, from: date).hour!):\(calender.dateComponents(in: TimeZone.current, from: date).minute!):\(calender.dateComponents(in: TimeZone.current, from: date).second!)"
    }
    
}








